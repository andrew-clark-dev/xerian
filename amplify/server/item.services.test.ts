import { vi } from 'vitest';
import { ItemServices } from './item-services';
import { DynamoService, DynamoServices } from './dynamodb-service';

function createMockDynamoService(): DynamoService {
    const mockInstance = new DynamoService('MockTable');

    // Overwrite methods with mocks
    mockInstance.exists = vi.fn();
    mockInstance.write = vi.fn();
    mockInstance.read = vi.fn();
    mockInstance.update = vi.fn();
    mockInstance.appendToArray = vi.fn();

    return mockInstance;
}

// Create mock implementations of all services
const mockDynamoServices: DynamoServices = {
    user: createMockDynamoService(),
    account: createMockDynamoService(),
    item: createMockDynamoService(),
    itemGroup: createMockDynamoService(),
    sale: createMockDynamoService(),
    transaction: createMockDynamoService(),
    itemCategory: createMockDynamoService(),
};

// Inject the service
const itemsService = new ItemServices(mockDynamoServices);

describe('importUser function', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    it('should return false as user exists', async () => {
        // 💡 Access the specific service
        (mockDynamoServices.user.exists as ReturnType<typeof vi.fn>).mockResolvedValue(true);

        const result = await itemsService.importUser({
            id: 'cee3343c-8a93-479f-b66e-673ef0e71dc5',
            name: 'andrew.at.encore',
            user_type: 'employee',
        });

        expect(result).toBe(false);
    });

    it('should return false as user exists', async () => {
        // 💡 Access the specific service
        (mockDynamoServices.user.exists as ReturnType<typeof vi.fn>).mockResolvedValue(false);
        (mockDynamoServices.user.write as ReturnType<typeof vi.fn>).mockResolvedValue(undefined);

        const result = await itemsService.importUser({
            id: 'cee3343c-8a93-479f-b66e-673ef0e71dc5',
            name: 'andrew.at.encore',
            user_type: 'employee',
        });

        expect(result).toBe(true);
    });
});

const mockItem = {
    "account": {
        "address_line_1": "Hildanussstrasse 3",
        "address_line_2": null,
        "balance": 10227,
        "city": null,
        "company": null,
        "created": "2020-01-20T16:59:35.912Z",
        "custom_fields": [],
        "deleted": null,
        "email": "carissa_clark@hotmail.com",
        "email_notifications_enabled": false,
        "first_name": "Carissa",
        "id": "81b2966b-965f-4ba7-9541-512dc121dcdf",
        "last_name": "Clark",
        "number": "000003",
        "phone_number": "0788278784",
        "postal_code": null,
        "state": null
    },
    "brand": null,
    "category": null,
    "color": null,
    "cost_per": null,
    "created": "2020-01-20T19:45:26.552Z",
    "created_by": {
        "id": "cee3343c-8a93-479f-b66e-673ef0e71dc5",
        "name": "andrew.at.encore",
        "user_type": "employee"
    },
    "custom_fields": [],
    "custom_fields_map": {},
    "days_on_shelf": 1910,
    "deleted": null,
    "description": null,
    "details": null,
    "expires": null,
    "id": "529bbcb9-edf9-40ca-957d-f4ec0a3866dd",
    "inventory_type": "consignment",
    "last_sold": null,
    "last_viewed": "2025-02-08T13:28:58.531Z",
    "printed": "2022-11-29T09:51:13.369Z",
    "quantity": 0,
    "schedule_start": "2020-01-20",
    "shelf": null,
    "shopify_product_id": null,
    "size": null,
    "sku": "000001",
    "split": 0.4,
    "split_price": 1000,
    "status": {
        "active": 0,
        "donated": 1
    },
    "tag_price": 1000,
    "tax_exempt": false,
    "terms": "donate",
    "title": ""
}

describe('importItem function', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    it('should return false as user exists', async () => {
        // 💡 Access the specific service
        (mockDynamoServices.item.exists as ReturnType<typeof vi.fn>).mockResolvedValue(true);

        const result = await itemsService.importItem(mockItem);

        expect(result).toBe(false);
    });

    it('should return false as user exists', async () => {
        // 💡 Access the specific service
        (mockDynamoServices.item.exists as ReturnType<typeof vi.fn>).mockResolvedValue(false);
        (mockDynamoServices.sale.exists as ReturnType<typeof vi.fn>).mockResolvedValue(true);

        const result = await itemsService.importItem(mockItem);

        expect(result).toBe(false);
    });

});

// vi.mock('"./itemServices', async () => {
//     return {
//         importUser: vi.fn(), // this replaces the real function with a mock
//         importAccount: vi.fn(), // this replaces the real function with a mock
//         importCategory: vi.fn(), // this replaces the real function with a mock
//         importItemGroup: vi.fn(), // this replaces the real function with a mock
//         importSales: vi.fn(), // this replaces the real function with a mock
//     };
// });

// describe('importItem function', () => {
//     it('Should accept basic Item object', () => {
//         // 👇 Cast each one to vi.Mock if needed for typings
//         const service = new DynamoService("Test"); // 👈 your test param

//         (importUser as jest.Mock).mockResolvedValue(true);
//         (importAccount as jest.Mock).mockResolvedValue(true);
//         (importCategory as jest.Mock).mockResolvedValue(true);
//         (importItemGroup as jest.Mock).mockResolvedValue(true);
//         (importSales as jest.Mock).mockResolvedValue(true);
//         jest.spyOn(itemDbService, 'write').mockResolvedValue();

//         expect(
//             importItem(
//                 {
//                     "account": {
//                         "address_line_1": "Hildanussstrasse 3",
//                         "address_line_2": null,
//                         "balance": 10227,
//                         "city": null,
//                         "company": null,
//                         "created": "2020-01-20T16:59:35.912Z",
//                         "custom_fields": [],
//                         "deleted": null,
//                         "email": "carissa_clark@hotmail.com",
//                         "email_notifications_enabled": false,
//                         "first_name": "Carissa",
//                         "id": "81b2966b-965f-4ba7-9541-512dc121dcdf",
//                         "last_name": "Clark",
//                         "number": "000003",
//                         "phone_number": "0788278784",
//                         "postal_code": null,
//                         "state": null
//                     },
//                     "brand": null,
//                     "category": null,
//                     "color": null,
//                     "cost_per": null,
//                     "created": "2020-01-20T19:45:26.552Z",
//                     "created_by": {
//                         "id": "cee3343c-8a93-479f-b66e-673ef0e71dc5",
//                         "name": "andrew.at.encore",
//                         "user_type": "employee"
//                     },
//                     "custom_fields": [],
//                     "custom_fields_map": {},
//                     "days_on_shelf": 1910,
//                     "deleted": null,
//                     "description": null,
//                     "details": null,
//                     "expires": null,
//                     "id": "529bbcb9-edf9-40ca-957d-f4ec0a3866dd",
//                     "inventory_type": "consignment",
//                     "last_sold": null,
//                     "last_viewed": "2025-02-08T13:28:58.531Z",
//                     "printed": "2022-11-29T09:51:13.369Z",
//                     "quantity": 0,
//                     "schedule_start": "2020-01-20",
//                     "shelf": null,
//                     "shopify_product_id": null,
//                     "size": null,
//                     "sku": "000001",
//                     "split": 0.4,
//                     "split_price": 1000,
//                     "status": {
//                         "active": 0,
//                         "donated": 1
//                     },
//                     "tag_price": 1000,
//                     "tax_exempt": false,
//                     "terms": "donate",
//                     "title": ""
//                 }

//             )).toBe(true);
//     });

// });


