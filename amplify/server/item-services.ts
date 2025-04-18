import { dynamoServices, DynamoServices } from "./dynamodb-service";
import { ExternalUser, ExternalAccount, ExternalItem, ExternalSale } from "./consigncloud/http-client-types";
import { isMobileNumber, comunicationPreferences, toISO, toStatus } from "./import.utils";
import { v4 as uuid4 } from 'uuid';
import { capitalize } from 'lodash';
import { fetchItemSales, getSale } from "./consigncloud/http-client-service";
import { logger } from "./logger";

export const IMPORT_SERVICE_USER_ID = 'f838ed77-7eec-4d85-85f8-ca022ff42a84'

const initialSettings = {
    apiKey: null,
    notifications: true,
    theme: 'light',
    hasLogin: false,
};


export class ItemServices {

    private db: DynamoServices;

    constructor(dynamoServices: DynamoServices) {
        this.db = dynamoServices;
    }

    async importItem(externalItem: ExternalItem): Promise<boolean> {
        logger.info('importItem', externalItem);
        // Check if the item already exists in the database
        if (await this.db.item.exists({ sku: externalItem.sku })) { return false }

        // Import user
        logger.info('externalItem.created_by', externalItem.created_by);
        await this.importUser(externalItem.created_by);

        // Import account
        await this.importAccount(externalItem.account);

        // Import categories
        await this.importCategory('Category', externalItem.category?.name);
        await this.importCategory('Brand', externalItem.brand);
        await this.importCategory('Color', externalItem.color);
        await this.importCategory('Size', externalItem.size);

        // Create a new account    
        await this.db.item.write({
            __typename: 'Item',
            id: externalItem.id,
            sku: externalItem.sku,
            lastActivityBy: externalItem.created_by?.id ?? IMPORT_SERVICE_USER_ID,
            title: externalItem.title,
            accountNumber: externalItem.account?.number,
            category: externalItem.category?.name,
            brand: externalItem.brand,
            color: externalItem.color,
            size: externalItem.size,
            description: externalItem.description,
            details: externalItem.details,
            condition: 'Unknown',
            split: externalItem.split ? Math.round(externalItem.split * 100) : null,
            price: externalItem.tag_price,
            status: toStatus(externalItem.status),
            sales: [],
            printedAt: toISO(externalItem.printed),
            lastSoldAt: toISO(externalItem.last_sold),
            lastViewedAt: toISO(externalItem.last_viewed),
            createdAt: toISO(externalItem.created),
            updatedAt: new Date().toISOString(),
            deletedAt: toISO(externalItem.deleted),
        });

        await this.importItemGroup(externalItem);
        await this.importSales(externalItem);


        return true;
    }

    async importUser(user: ExternalUser | null | undefined): Promise<boolean> {
        logger.info('importUser', user);

        if (!user) { return false }
        // Check if the user already exists in the database
        if (await this.db.user.exists({ id: user.id })) { return false }
        // Create a new user profile
        await this.db.user.write({
            __typename: 'UserProfile',
            id: user.id,
            status: "Active",
            role: user.user_type,
            nickname: user.name,
            settings: JSON.stringify(initialSettings),
        });
        return true;

    }


    async importAccount(externalAccount: ExternalAccount | null | undefined): Promise<boolean> {
        logger.info('importAccount', externalAccount);

        if (!externalAccount) { return false }

        // Check if the account already exists in the database
        if (await this.db.account.exists({ number: externalAccount.number })) { return false }

        // Import user
        await this.importUser(externalAccount.created_by);

        // Create a new account    
        await this.db.account.write({
            __typename: 'Account',
            id: externalAccount.id,
            number: externalAccount.number,
            lastActivityBy: externalAccount.created_by?.id ?? IMPORT_SERVICE_USER_ID,
            firstName: externalAccount.first_name,
            lastName: externalAccount.last_name,
            email: externalAccount.email,
            phoneNumber: externalAccount.phone_number,
            isMobile: isMobileNumber(externalAccount.phone_number),
            addressLine1: externalAccount.address_line_1,
            addressLine2: externalAccount.address_line_2,
            city: externalAccount.city,
            state: externalAccount.state,
            postcode: externalAccount.postal_code,
            comunicationPreferences: comunicationPreferences(externalAccount.phone_number, externalAccount.email),
            status: externalAccount.deleted ? "Inactive" : "Active",
            kind: externalAccount.tags?.includes("VIP") ? "VIP" : externalAccount.tags?.includes("Vitrine") ? "Vender" : "Standard",
            defaultSplit: externalAccount.default_split ? Math.round(externalAccount.default_split * 100) : null,
            // items: a.hasMany("Item", "accountNumber"), // setup relationships between main types
            // transactions: a.string().array(), // this is the list of transaction ids that this item has been involved in.
            balance: externalAccount.balance ?? 0,
            noItems: externalAccount.number_of_items ?? 0,
            lastActivityAt: toISO(externalAccount.last_activity),
            lastItemAt: toISO(externalAccount.last_item_entered),
            lastSettlementAt: toISO(externalAccount.last_settlement),
            tags: externalAccount.tags,
            createdAt: toISO(externalAccount.created),
            updatedAt: new Date().toISOString(),
            deletedAt: toISO(externalAccount.deleted),
        });
        return true;
    }
    async importItemGroup(externalItem: ExternalItem): Promise<boolean> {
        // Check if more than 1 item is in the group
        if ((externalItem.quantity ?? 0) < 2) { return false }

        this.db.itemGroup.write({
            __typename: 'ItemGroup',
            id: uuid4(),
            quantity: externalItem.quantity,
            statuses: JSON.stringify(externalItem.status),
            itemSku: externalItem.sku,
        });
        return true;
    }

    async importSales(externalItem: ExternalItem): Promise<boolean> {
        logger.info('importSales', externalItem);
        // Get sales
        let cursor = null;
        let hasMorePages = true;

        while (hasMorePages) {
            const { data, next_cursor } = await fetchItemSales({
                cursor: cursor,
                itemId: externalItem.id,
            });


            cursor = next_cursor;
            hasMorePages = cursor ? true : false;
            for (const itemSale of data) {
                const externalSale = await getSale(itemSale.id);
                if (!externalSale) { continue }
                // Check if the sale already exists in the database
                const sale = await this.db.sale.read({ id: itemSale.id });
                if (sale) {
                    await this.db.sale.appendToArray(
                        { id: sale.id },
                        'items',
                        [{
                            sku: externalItem.sku,
                            title: externalItem.title,
                            category: externalItem.category?.name,
                            brand: externalItem.brand,
                            color: externalItem.color,
                            size: externalItem.size,
                            description: externalItem.description,
                            details: externalItem.details,
                            condition: 'Unknown',
                            split: externalItem.split ? Math.round(externalItem.split * 100) : null,
                            price: externalItem.tag_price,
                        }],
                    );
                    await this.db.item.appendToArray(
                        { id: externalItem.id },
                        'sales',
                        [sale.id],
                    );
                } else {
                    // Import user
                    await this.importUser(externalSale.cashier);

                    // Import account
                    await this.importAccount(externalSale.customer);

                    const transactionId = await this.createTransaction(externalSale);

                    // Create a new sale
                    await this.db.sale.write({
                        __typename: 'Sale',
                        id: externalSale.id,
                        number: externalSale.number,
                        lastActivityBy: externalSale.cashier?.id ?? IMPORT_SERVICE_USER_ID,
                        // customerEmail: 
                        customerAccount: externalSale.customer?.id, // the account number of the customer if exists
                        finalizedAt: toISO(externalSale.finalized),
                        parkedAt: toISO(externalSale.finalized),
                        voidedAt: toISO(externalSale.voided),
                        status: capitalize(externalSale.status),
                        subTotal: externalSale.subtotal,
                        total: externalSale.total,
                        taxes: externalSale.taxes, // we only track MWST
                        change: externalSale.change,
                        refund: externalSale.refunded_amount,
                        accountTotal: externalSale.consignor_portion,
                        storeTotal: externalSale.store_portion,
                        transaction: transactionId,
                        items: [{
                            sku: externalItem.sku,
                            title: externalItem.title,
                            category: externalItem.category?.name,
                            brand: externalItem.brand,
                            color: externalItem.color,
                            size: externalItem.size,
                            description: externalItem.description,
                            details: externalItem.details,
                            condition: 'Unknown',
                            split: externalItem.split ? Math.round(externalItem.split * 100) : null,
                            price: externalItem.tag_price,
                        }],
                        receipt_url: externalSale.receipt_url,
                        createdAt: toISO(externalSale.created),
                        updatedAt: new Date().toISOString(),
                    });
                    await this.db.item.appendToArray(
                        { id: externalItem.id },
                        'sales',
                        [externalSale.id],
                    );
                }
            }
        }
        return true;
    }

    async createTransaction(externalSale: ExternalSale): Promise<string> {

        const id = uuid4();
        await this.db.transaction.write({
            __typename: 'Transaction',
            id: id,
            createdAt: toISO(externalSale.created),
            updatedAt: new Date().toISOString(),
            lastActivityBy: externalSale.cashier?.id ?? IMPORT_SERVICE_USER_ID,
            type: 'Sale',
            amount: externalSale.total_tendered,
            amountsTendered: JSON.parse(JSON.stringify(externalSale.amounts_tendered).replaceAll("_", "")),
            taxes: externalSale.taxes, // we only track MWST
            status: 'Completed',
        })
        return id;
    }

    async importCategory(kind: string, name?: string | null): Promise<boolean> {
        if (!name) { return false }
        // Check if the item already exists in the database
        if (await this.db.itemCategory.exists({ kind, name })) { return false }

        await this.db.itemCategory.write({
            __typename: 'ItemCategory',
            lastActivityBy: IMPORT_SERVICE_USER_ID,
            categoryKind: kind,
            kind: kind,
            name: name,
            matchNames: name,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
        })
        return true;

    }
}

export const itemServices = new ItemServices(dynamoServices);