import ky from 'ky';
import { ExternalAccount, ExternalItem, ExternalItemSale, ExternalSale } from './http-client-types';

// Define response type
interface PagedResponse<T> {
  count: number;
  next_cursor: string | null;
  data: T[];
}

const httpCall = ky.create({
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*', // Allow all origins
    'Authorization': `Bearer ${process.env.API_KEY}`,
  },
  retry: {
    limit: 5,
    statusCodes: [429], // 👈 still specify this if you want 429 retries
  }
});


const searchParams = new URLSearchParams()
searchParams.set('limit', '100');
searchParams.set('sort_by', 'created');
['created_by', 'category', 'account']
  .forEach(expand => { searchParams.append('expand', expand); });

['created_by', 'days_on_shelf', 'last_sold', 'last_viewed', 'printed', 'split_price', 'tax_exempt', 'quantity']
  .forEach(include => { searchParams.append('include', include); });

// Fetcher function
export async function fetchPagedItems(params: {
  cursor: string | null;
  createdGte?: string;
  createdLt?: string;
}): Promise<PagedResponse<ExternalItem>> {
  try {

    if (params.cursor) searchParams.set('cursor', params.cursor);
    if (params.createdGte) searchParams.set('created:gte', params.createdGte);
    if (params.createdLt) searchParams.set('created:lt', params.createdLt);
    console.info('searchParams', searchParams);
    const response = await httpCall
      .get('https://api.consigncloud.com/api/v1/items', { searchParams })
      .json<PagedResponse<ExternalItem>>();

    return response;
  } catch (error) {
    console.error('Error fetching paged items:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}


const accountParams = new URLSearchParams();

['default_split', 'last_settlement', 'number_of_purchases', 'default_inventory_type', 'default_terms',
  'last_item_entered', 'number_of_items', 'created_by', 'last_activity', 'locations', 'recurring_fees', 'tags']
  .forEach(include => { accountParams.append('include', include); });

export async function getAccount(id: string): Promise<ExternalAccount> {
  try {

    const response = await httpCall
      .get(`https://api.consigncloud.com/api/v1/accounts/${id}`, { searchParams: accountParams })
      .json<ExternalAccount>();

    return response;
  } catch (error) {
    console.error('Error fetching paged items:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}

const itemSalesParams = new URLSearchParams();
itemSalesParams.set('limit', '100');

export async function fetchItemSales(params: {
  cursor: string | null;
  itemId: string;
}): Promise<PagedResponse<ExternalItemSale>> {
  try {

    if (params.cursor) itemSalesParams.set('cursor', params.cursor);

    console.info('itemSalesParams', itemSalesParams);
    const response = await httpCall
      .get(`https://api.consigncloud.com/api/v1/items/${params.itemId}/sales`, { searchParams: itemSalesParams })
      .json<PagedResponse<ExternalItemSale>>();

    return response;
  } catch (error) {
    console.error('Error fetching paged items:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}

const saleParams = new URLSearchParams();


['receipt_url', 'cashier', 'customer', 'customer.email_notifications_enabled', 'customer.address_line_1',
  'customer.address_line_2', 'customer.city', 'customer.state', 'customer.postal_code', 'customer.tags',
  'amounts_tendered', 'total_tendered']
  .forEach(include => { saleParams.append('include', include); });
['cashier', 'customer'].forEach(expand => { saleParams.append('expand', expand); });

export async function getSale(id: string): Promise<ExternalSale> {
  try {

    const response = await httpCall
      .get(`https://api.consigncloud.com/api/v1/sales/${id}`, { searchParams: saleParams })
      .json<ExternalSale>();

    return response;
  } catch (error) {
    console.error('Error fetching paged items:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}