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
export function isMobileNumber(phoneNumber?: string | null): boolean {
    const mobileRegex = /078|076|079|(0).*78|(0).*76|(0).*79/gm;
    return mobileRegex.test(phoneNumber ?? '');
}

/**
* Calculates the communication preferences based on the phone number and email address
* @param exAccount The account read from thee external system.
* @returns The communication preferences
*/
export function comunicationPreferences(phoneNumber: string | null, email?: string | null): "TextMessage" | "Email" | "None" {
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
