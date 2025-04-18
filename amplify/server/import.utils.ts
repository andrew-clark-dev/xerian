import { ExternalItemStatus } from './consigncloud/http-client-types';

export function money(text?: string | null): number {
    if (!text) {
        return 0;
    }
    // handle the case where CHF is in the text
    const cleanText = text.trim().replace('CHF', '');
    return Math.round(parseFloat(cleanText) * 100);
}

export function split(text?: string | null): number {
    if (!text) {
        return 0;
    }
    // handle the case where % is in the text
    const cleanText = text.replace('%', '');
    return parseInt(cleanText);
}


/**
* Checks if an accoutn phone number indicates a mobile number based on Swiss mobile prefixes
* @param exAccount The account read from thee external system.
* @returns A boolean indicating if the number is a mobile number
*/
export function isMobileNumber(phoneNumber?: string | null | undefined): boolean {
    const mobileRegex = /^(0|\(0\))7[5-9]/;
    return mobileRegex.test(phoneNumber?.trim() ?? '');
}

/**
* Calculates the communication preferences based on the phone number and email address
* @param exAccount The account read from thee external system.
* @returns The communication preferences
*/
export function comunicationPreferences(phoneNumber: string | null | undefined, email?: string | null | undefined): "TextMessage" | "Email" | "None" {
    if (isMobileNumber(phoneNumber)) {
        return "TextMessage";
    }
    if (email) {
        return "Email";
    }
    return "None";
}

/**
 * Parses a date string and returns it in ISO format
 * @param datestring any date string that can be converted to a date
 * @returns the date string in ISO format
 */
export function toISO(datestring?: string | null): string | null {
    try {
        if (datestring) {
            if (datestring.length === 0) { return null; }
            return new Date(datestring).toISOString();
        }
        return null;
    } catch (error) {
        console.error(`Error parsing date: ${datestring}`, error);
        return null;
    }
}

type ItemStatus = 'Created' | 'Tagged' | 'Active' | 'Sold' | 'ToDonate' | 'Donated' | 'Parked' | 'Returned' | 'Expired' | 'Lost' | 'Stolen' | 'Multi' | 'Unknown';


export function toStatus(status: ExternalItemStatus): ItemStatus {
    if (((status.sold ?? 0) + (status.sold_on_legacy ?? 0) + (status.sold_on_shopify ?? 0) + (status.sold_on_square ?? 0) + (status.sold_on_third_party ?? 0)) > 0) return 'Sold';
    if (status.active ?? 0 > 0) return 'Active';
    if (status.parked ?? 0 > 0) return 'Parked';
    if (status.lost ?? 0 > 0) return 'Lost';
    if (status.stolen ?? 0 > 0) return 'Stolen';
    if (status.donated ?? 0 > 0) return 'Donated';
    return 'Unknown';
}
