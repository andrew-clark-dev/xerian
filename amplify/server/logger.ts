import { Logger } from "@aws-lambda-powertools/logger";

class PrettyLogger {
    private logger: Logger;

    constructor(serviceName: string) {
        this.logger = new Logger({ serviceName });
    }


    private formattedMessage(message: string, obj?: object | null | unknown): string {
        let formattedMessage = message;
        if (obj) {
            const cleanedObject = JSON.stringify(obj).replace(/\\"/g, "'");
            formattedMessage += ` : ${cleanedObject}`;
        }
        return formattedMessage;
    }

    private log(level: "info" | "warn" | "error", message: string, obj?: object | null | unknown): void {
        this.logger[level](this.formattedMessage(message, obj));
    }

    info(message: string, obj?: object | null | unknown): void {
        this.log("info", message, obj);
    }

    warn(message: string, obj?: object): void {
        this.log("warn", message, obj);
    }

    error(message: string, obj?: unknown): void {
        this.log("error", message, obj as object);
    }

    /**
     * Condidtionally logs an error message and throws an error if error is not null or undefined
     * @param message the error message
     * @param error the error object
     * @throws Error if error is not null or undefined
     */
    ifErrorThrow(message: string, error?: unknown): void {
        if (!error) { return } // No need to throw if there is no error
        const _error = error as object;
        this.log("error", message, _error);
        if (_error instanceof Error) {
            throw new Error(message, { cause: _error });
        }
        throw new Error(this.formattedMessage(message, _error));
    }
}

const serviceName = process.env.SERVICE_NAME || process.env.AWS_LAMBDA_FUNCTION_NAME || "UnknownService";
export const logger = new PrettyLogger(serviceName);

// Usage Example
// logger.info("User login attempt", { userId: 123, ip: "192.168.1.1" });

