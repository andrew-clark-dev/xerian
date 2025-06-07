import { handler } from './handler.fetch.item';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { fetchPagedItems } from '../../src/http-client-service';
import { mockClient } from 'aws-sdk-client-mock';
import 'aws-sdk-client-mock-jest';

jest.mock('../lib/http-client-service', () => ({
    fetchPagedItems: jest.fn(),
}));

const s3Mock = mockClient(S3Client);

describe('handler.fetch.item', () => {
    beforeEach(() => {
        s3Mock.reset();
        process.env.BUCKET_NAME = 'test-bucket';
    });

    it('should fetch data and write to S3', async () => {
        const mockData = [{ id: 1, name: 'test' }];
        const mockCursor = 'next-cursor-123';

        (fetchPagedItems as jest.Mock).mockResolvedValue({
            data: mockData,
            next_cursor: mockCursor,
        });

        s3Mock.on(PutObjectCommand).resolves({});

        const event = { cursor: 'prev-cursor-abc' };
        const result = await handler(event);

        expect(fetchPagedItems).toHaveBeenCalledWith({ cursor: 'prev-cursor-abc' });

        expect(s3Mock).toHaveReceivedCommandWith(PutObjectCommand, {
            Bucket: 'test-bucket',
            Key: expect.stringMatching(/^import\/fetched\/item\/.*\.json$/),
            Body: JSON.stringify(mockData),
            ContentType: 'application/json',
        });

        expect(result).toHaveProperty('cursor', mockCursor);
        expect(result).toHaveProperty('key');
    });

    it('should handle missing cursor', async () => {
        (fetchPagedItems as jest.Mock).mockResolvedValue({
            data: [],
            next_cursor: null,
        });

        s3Mock.on(PutObjectCommand).resolves({});

        const result = await handler({});

        expect(fetchPagedItems).toHaveBeenCalledWith({ cursor: null });
        expect(result.cursor).toBeNull();
    });
});