import { Logger } from "@aws-lambda-powertools/logger";

class PrettyLogger {
    private logger: Logger;

    constructor(serviceName: string) {
        this.logger = new Logger({ serviceName });
    }


    private formattedData(obj?: object | null | unknown): string {
        return obj ? JSON.stringify(obj).replace(/\\"/g, "'") : "";
    }

    private log(level: "info" | "warn" | "error", message: string, obj?: object | null | unknown): void {
        this.logger[level](message, { data: this.formattedData(obj) });
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
     * Logs a message with the outcome SUCCESS
     * @param message the message to log
     * @param obj Extra data to log
     */
    success(message: string, obj?: object | null | unknown): void {
        this.logger["info"](message, { data: this.formattedData(obj), outcome: "SUCCESS" });
    }

    /**
     * Logs a message with the outcome FAILURE
     * @param message the message to log
     * @param obj Extra data to log
     */
    failure(message: string, obj?: object | null | unknown): void {
        this.logger["error"](message, { data: this.formattedData(obj), outcome: "FAILURE" });
    }

    /**
     * Logs a message with the outcome START, use to log the start of a process
     * @param message the message to log
     * @param obj Extra data to log
     */
    start(message: string, obj?: object | null | unknown): void {
        this.logger["info"](message, { data: this.formattedData(obj), outcome: "START" });
    }

    /**
     * Conditionally logs an error message and throws an error if error is not null or undefined
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
        throw new Error(message + " : " + JSON.stringify(_error));
    }
}

const serviceName = process.env.SERVICE_NAME || process.env.AWS_LAMBDA_FUNCTION_NAME || "UnknownService";
export const logger = new PrettyLogger(serviceName);

// Usage Example
// logger.info("User login attempt", { userId: 123, ip: "192.168.1.1" });

