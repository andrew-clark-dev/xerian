import ky, { HTTPError } from 'ky';
import { ExternalAccount, ExternalItem, ExternalSale } from './http-client-types';
import { logger } from "./logger";

const BASE_URL = 'https://api.consigncloud.com/api/v1';

function buildParams(includes: string[], expands: string[] = []): URLSearchParams {
  const params = new URLSearchParams();
  includes.forEach(i => params.append('include', i));
  expands.forEach(e => params.append('expand', e));
  return params;
}

// Define response type
interface PagedResponse<T> {
  count: number;
  next_cursor: string | null;
  data: T[];
}

interface RetryableError extends Error {
  name: 'TooManyRequestsException';
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



// Fetcher function
export async function fetchPagedItems(params: {
  cursor: string | null;
  createdGte?: string;
  createdLt?: string;
}): Promise<PagedResponse<ExternalItem>> {
  try {
    const searchParams = buildParams(
      ['created_by', 'days_on_shelf', 'last_sold', 'last_viewed', 'printed', 'split_price', 'tax_exempt', 'quantity'],
      ['created_by', 'category', 'account']
    );
    searchParams.set('limit', '100');
    searchParams.set('sort_by', 'created');
    if (params.cursor) searchParams.set('cursor', params.cursor);
    if (params.createdGte) searchParams.set('created:gte', params.createdGte);
    if (params.createdLt) searchParams.set('created:lt', params.createdLt);
    logger.info('searchParams', searchParams);
    const response = await httpCall
      .get(`${BASE_URL}/items`, { searchParams })
      .json<PagedResponse<ExternalItem>>();

    return response;
  } catch (error) {
    if (error instanceof HTTPError && error.response.status === 429) {
      const err: RetryableError = new Error('Throttled') as RetryableError;
      err.name = 'TooManyRequestsException';
      throw err;
    }
    if (error instanceof HTTPError && error.response.status === 404) {
      const notFoundError = new Error('Not found');
      notFoundError.name = 'ResourceNotFoundException';
      throw notFoundError;
    }
    logger.error('Error fetching paged items:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}

export async function getItem(id: string): Promise<ExternalItem> {
  try {
    const searchParams = buildParams(
      ['printed', 'split_price', 'tax_exempt', 'tags', 'quantity'],
      ['category', 'account']
    );
    const response = await httpCall
      .get(`${BASE_URL}/items/${id}`, { searchParams })
      .json<ExternalItem>();

    return response;
  } catch (error) {
    logger.error('Error fetching paged items:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}


export async function getAccount(id: string): Promise<ExternalAccount> {
  try {
    const searchParams = buildParams([
      'default_split', 'last_settlement', 'number_of_purchases', 'default_inventory_type', 'default_terms',
      'last_item_entered', 'number_of_items', 'created_by', 'last_activity', 'locations', 'recurring_fees', 'tags'
    ]);
    const response = await httpCall
      .get(`${BASE_URL}/accounts/${id}`, { searchParams })
      .json<ExternalAccount>();

    return response;
  } catch (error) {
    logger.error('Error fetching paged items:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}

const itemSalesParams = new URLSearchParams();
itemSalesParams.set('limit', '100');

export async function getSale(id: string): Promise<ExternalSale> {
  try {
    const searchParams = buildParams(
      [
        'receipt_url', 'cashier', 'customer', 'customer.email_notifications_enabled', 'customer.address_line_1',
        'customer.address_line_2', 'customer.city', 'customer.state', 'customer.postal_code', 'customer.tags',
        'amounts_tendered', 'total_tendered'
      ],
      ['cashier', 'customer']
    );
    const response = await httpCall
      .get(`${BASE_URL}/sales/${id}`, { searchParams })
      .json<ExternalSale>();

    return response;
  } catch (error) {
    logger.error('Error getting sale:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}


export async function fetchPagedSales(params: {
  cursor: string | null;
  createdGte?: string;
  createdLt?: string;
}): Promise<PagedResponse<ExternalSale>> {
  try {
    const searchParams = buildParams(
      [
        'receipt_url', 'cashier', 'customer', 'customer.email_notifications_enabled', 'customer.address_line_1',
        'customer.address_line_2', 'customer.city', 'customer.state', 'customer.postal_code', 'customer.tags',
        'amounts_tendered', 'total_tendered'
      ],
      ['cashier', 'customer']
    );
    if (params.cursor) searchParams.set('cursor', params.cursor);
    if (params.createdGte) searchParams.set('created:gte', params.createdGte);
    if (params.createdLt) searchParams.set('created:lt', params.createdLt);
    logger.info('salesParams', searchParams);
    const response = await httpCall
      .get(`${BASE_URL}/sales`, { searchParams })
      .json<PagedResponse<ExternalSale>>();

    return response;
  } catch (error) {
    if (error instanceof HTTPError && error.response.status === 404) {
      return {
        count: 0,
        next_cursor: null,
        data: [],
      };
    }
    logger.error('Error fetching paged sales:', (error as Error).message);
    throw error; // Rethrow the error for handling in the calling function
  }
}