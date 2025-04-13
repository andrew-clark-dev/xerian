import ky from 'ky';

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

export interface ExternalUser {
  id: string,
  name: string,
  user_type: string,
}

export interface ExternalItem {
  account: {
    id: string,
    number: string,
  } | null,
  brand: string | null,
  category: {
    id: string,
    name: string,
  } | null,
  color: string | null,
  cost_per: number | null,
  created: string,
  created_by: ExternalUser,
  days_on_shelf?: number,
  deleted: string | null,
  description: string | null,
  details: string | null,
  id: string,
  inventory_type: string,
  last_sold?: string | null,
  last_viewed?: string | null,
  printed?: string | null,
  quantity?: number | null,
  shelf: string | null,
  shopify_product_id: string | null,
  size: string | null,
  sku: string,
  split: number | null,
  split_price: number | null,
  status: ExternalItemStatus,
  tag_price: number | null,
  tax_exempt?: boolean,
  terms: string | null,
  title: string | null,
}

export interface ExternalItemStatus {
  active: number,
  damaged: number,
  donated: number,
  lost: number,
  parked: number,
  returned_to_owner: number,
  sold: number,
  sold_on_legacy: number,
  sold_on_shopify: number,
  sold_on_square: number,
  sold_on_third_party: number,
  stolen: number,
  to_be_returned: number,
}

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
