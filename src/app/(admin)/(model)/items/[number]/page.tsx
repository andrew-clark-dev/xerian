// app/form/page.tsx
"use server";
import { notFound } from 'next/navigation';
import AccountForm, { Account } from './AccountForm';
import { serverClient } from '@/lib/amplify-server-utils';

export default async function Page({ params }: { params: Promise<{ number: string }> }) {
  const { number } = await params

  const { data, errors } = await serverClient.models.Account.get(
    { number },
    {
      selectionSet: [
        'number',
        'firstName',
        'lastName',
        'email',
        'phoneNumber',
        'isMobile',
        'createdAt',
        'updatedAt',
        'deletedAt',
        'lastActivityBy',
        'addressLine1',
        'addressLine2',
        'city',
        'state',
        'postcode',
        'comunicationPreferences',
        'status',
        'kind',
        'defaultSplit',
        'transactions',
        'balance',
        'noSales',
        'noItems',
        'lastActivityAt',
        'lastItemAt',
        'lastSettlementAt',
        'tags',
      ]
    }
  );

  if (errors) {
    console.error(`Get Account errors: ${errors}`);
  }
  if (!data) {
    console.warn(`Account with number ${number} not found`);
    notFound(); // 👈 this triggers the 404 page
  }

  const account = data as Account;
  console.info(`Account : ${JSON.stringify(account)}`);

  return (<AccountForm account={account} />);
}
