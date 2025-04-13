import { fetchPagedItemsWithRetry } from './http-client-service';


describe('add function', () => {
    it('Should fetch items from ConsignCloud', () => {
        expect(
            fetchPagedItemsWithRetry({
                cursor: null,
                createdGte: '2020-01-01T00:00:00.000Z',
                createdLt: '2020-01-01T00:00:00.000Z',
            })).toBeDefined();
    });


});
