"use client";
import React, { useState } from "react";
import Link from "next/link";
import Label from "../form/Label";
import Input from "@/components/form/input/InputField";
import { resetPassword } from 'aws-amplify/auth';
import { toast } from 'sonner';
import { useRouter } from "next/navigation";

export default function ResetPasswordForm() {
  const router = useRouter();

  const [email, setEmail] = useState("");

  const sendCode = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const { nextStep } = await resetPassword({ username: email });
      switch (nextStep.resetPasswordStep) {
        case 'CONFIRM_RESET_PASSWORD_WITH_CODE':
          console.log("Next step : CONFIRM_RESET_PASSWORD_WITH_CODE");
          const codeDeliveryDetails = nextStep.codeDeliveryDetails;
          toast.success(`Confirmation code was sent to ${codeDeliveryDetails.deliveryMedium}`, {
            onDismiss: () => {
              // Redirect after toast is closed
              router.push("/confirm-password"); // Replace with your desired route
            }
          });
          break;
        default:
          console.log(`Next step : ${nextStep}`);
          toast.error(`Could not reset password please contact your administrator`);
      }
    } catch (err: unknown) {
      if (err instanceof Error) {
        console.log("Form error:" + err.message);
        toast.error(err.message || 'Reset failed. Please try again.');

      } else {
        toast.error('Reset failed. Please try again.');
      }
    }
  };


  return (
    <div className="flex flex-col flex-1 lg:w-1/2 w-full">
      <div className="w-full max-w-md pt-10 mx-auto">
        <Link
          href="/"
          className="inline-flex items-center text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"
        >
          <svg
            className="stroke-current"
            xmlns="http://www.w3.org/2000/svg"
            width="20"
            height="20"
            viewBox="0 0 20 20"
            fill="none"
          >
            <path
              d="M12.7083 5L7.5 10.2083L12.7083 15.4167"
              stroke=""
              strokeWidth="1.5"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
          Back to dashboard
        </Link>
      </div>
      <div className="flex flex-col justify-center flex-1 w-full max-w-md mx-auto">
        <div className="mb-5 sm:mb-8">
          <h1 className="mb-2 font-semibold text-gray-800 text-title-sm dark:text-white/90 sm:text-title-md">
            Forgot Your Password?
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400">
            Enter the email address linked to your account, and we’ll send you a
            link to reset your password.
          </p>
        </div>
        <div>
          <form onSubmit={sendCode}>
            <div className="space-y-5">
              {/* <!-- Email --> */}
              <div>
                <Label>
                  Email<span className="text-error-500">*</span>
                </Label>
                <Input
                  type="email"
                  id="email"
                  name="email"
                  placeholder="Enter your email"
                  onChange={(e) => setEmail(e.target.value)}
                />
              </div>

              {/* <!-- Button --> */}
              <div>
                <button className="flex items-center justify-center w-full px-4 py-3 text-sm font-medium text-white transition rounded-lg bg-brand-500 shadow-theme-xs hover:bg-brand-600">
                  Send Reset Link
                </button>
              </div>
            </div>
          </form>
          <div className="mt-5">
            <p className="text-sm font-normal text-center text-gray-700 dark:text-gray-400 sm:text-start">
              Wait, I remember my password...
              <Link
                href="/"
                className="text-brand-500 hover:text-brand-600 dark:text-brand-400"
              >
                Click here
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
