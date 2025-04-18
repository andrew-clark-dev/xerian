import { isMobileNumber, toStatus } from "./import.utils";


describe('isMobileNumber function', () => {
    it('Should returns true for a number starting with 079', () => {
        expect(
            isMobileNumber("079 226 5910")).toBe(true);
    });
    it('Should returns true for a number starting with 078', () => {
        expect(
            isMobileNumber("078 226 5910")).toBe(true);
    });
    it('Should returns true for a number starting with 077', () => {
        expect(
            isMobileNumber("077 226 5910")).toBe(true);
    });
    it('Should returns true for a number starting with (0)79', () => {
        expect(
            isMobileNumber(" (0)79 226 5910")).toBe(true);
    });
    it('Should returns false for a number starting with  031', () => {
        expect(
            isMobileNumber("031 226 5910")).toBe(false);
    });
    it('Should returns false null', () => {
        expect(
            isMobileNumber(null)).toBe(false);
    });
});


describe('toStatus function', () => {
    it('Should returns Donated', () => {
        expect(
            toStatus({
                "active": 0,
                "donated": 1
            })).toBe('Donated');
    });
    it('Should returns Active', () => {
        expect(
            toStatus({
                "active": 1,
                "donated": 1
            })).toBe('Active');
    });
});