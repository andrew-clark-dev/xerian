import { CountryCode, parsePhoneNumberWithError } from 'libphonenumber-js';

export function formatInternational(phone: string, defaultCountry: CountryCode = 'CH'): string {
    try {
        const phoneNumber = parsePhoneNumberWithError(phone, defaultCountry);
        return phoneNumber.formatInternational(); // or formatNational()
    } catch {
        return phone; // fallback
    }
}

export function formatNational(phone: string | null | undefined, defaultCountry: CountryCode = 'CH'): string {
    if (!phone) {
        return 'None';
    }
    try {
        const phoneNumber = parsePhoneNumberWithError(phone, defaultCountry);
        return phoneNumber.formatNational();
    } catch {
        return phone; // fallback
    }
}


export function formatCurrency(value: number, currency: string = 'CHF', locale: string = 'de-CH'): string {
    return new Intl.NumberFormat(locale, {
        style: 'currency',
        currency,
    }).format(value / 100);
}