import { handler } from './handler.process.item';
import { S3Client, GetObjectCommand, PutObjectCommand, DeleteObjectCommand, CopyObjectCommand } from '@aws-sdk/client-s3';
import { mockClient } from 'aws-sdk-client-mock';
import 'aws-sdk-client-mock-jest';
import { Readable } from 'stream';
import { SdkStream } from '@smithy/types';

jest.mock('../../backend/services/item-services', () => ({
    itemServices: {
        importItem: jest.fn(),
    },
}));

const s3Mock = mockClient(S3Client);
import { itemServices } from '../lib/item-services';
const { importItem } = itemServices;

describe('handler.process.item', () => {
    const bucket = 'mock-bucket';
    process.env.TEMP_BUCKET_NAME = bucket;

    const mockData = [{ id: 1 }, { id: 2 }];

    const mockStream = (data: string): SdkStream<Readable> => {
        const readable = new Readable();
        readable.push(data);
        readable.push(null);
        return Object.assign(readable, {
            transformToString: () => Promise.resolve(data),
            transformToByteArray: () => Promise.resolve(Buffer.from(data)),
            transformToWebStream: () => new ReadableStream(),
        });
    };

    beforeEach(() => {
        s3Mock.reset();
        jest.clearAllMocks();
    });

    it('should process all items and move file to done folder', async () => {
        (importItem as jest.Mock).mockResolvedValue(undefined);

        s3Mock.on(GetObjectCommand).resolves({
            Body: mockStream(JSON.stringify(mockData)),
        });

        s3Mock.on(CopyObjectCommand).resolves({});
        s3Mock.on(DeleteObjectCommand).resolves({});

        const event = { key: 'fetched/item/test.json' };
        await handler(event);

        expect(importItem).toHaveBeenCalledTimes(2);
        expect(s3Mock).toHaveReceivedCommand(CopyObjectCommand);
        expect(s3Mock).toHaveReceivedCommand(DeleteObjectCommand);
    });

    it('should write errors to error folder when import fails', async () => {
        (importItem as jest.Mock)
            .mockResolvedValueOnce(undefined)
            .mockRejectedValueOnce(new Error('Failed to import'));

        s3Mock.on(GetObjectCommand).resolves({
            Body: mockStream(JSON.stringify(mockData)),
        });

        s3Mock.on(PutObjectCommand).resolves({});

        const event = { key: 'fetched/item/test.json' };
        await handler(event);

        expect(importItem).toHaveBeenCalledTimes(2);
        expect(s3Mock).toHaveReceivedCommandWith(PutObjectCommand, {
            Bucket: bucket,
            Key: 'error/test.json',
            ContentType: 'application/json',
        });
    });
});