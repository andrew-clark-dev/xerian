import ky from 'ky';
import { HTTPError } from 'ky';

// Define response type
interface PagedResponse<T> {
  count: number;
  next_cursor: string | null;
  data: T[];
}


const headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Access-Control-Allow-Origin': '*', // Allow all origins
  'Authorization': `Bearer ${process.env.API_KEY}`,
}

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
  const searchParams = new URLSearchParams({
    'include': 'created_by, days_on_shelf, last_sold, last_viewed, printed, split_price, tax_exempt, quantity',
    'expand': 'created_by, category, account',
    'sort_by': 'created',
    'limit': '100',
  })
  if (params.cursor) searchParams.set('cursor', params.cursor);
  if (params.createdGte) searchParams.set('created:gte', params.createdGte);
  if (params.createdLt) searchParams.set('created:lt', params.createdLt);

  const response = await ky
    .get('https://api.example.com/items', { headers, searchParams })
    .json<PagedResponse<ExternalItem>>();

  return response;
}

export async function fetchPagedItemsWithRetry(params: {
  cursor: string | null;
  createdGte?: string;
  createdLt?: string;
  retries?: number; // Number of retries before giving up
}): Promise<PagedResponse<ExternalItem>> {
  const maxRetries = 5; // Max number of retries
  let attempt = 0;

  while (attempt <= maxRetries) {
    try {
      return await fetchPagedItems(params);
    } catch (error) {
      if (error instanceof HTTPError && error.response && error.response.status === 429) {
        // If it's a 429, wait 5 seconds and retry
        attempt++;
        console.log(`404 error received, retrying... Attempt #${attempt}`);
        if (attempt > maxRetries) {
          throw new Error('Maximum retries reached for 429 errors.');
        }
        await delay(2000); // Wait for 2 seconds before retrying
      } else {
        // Throw other errors immediately
        throw error;
      }
    }
  }

  throw new Error('Unexpected error occurred during retries');
}

// Helper function to delay for a specified time
function delay(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}