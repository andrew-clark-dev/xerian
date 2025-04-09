"use client";

import { useForm } from 'react-hook-form';
import { useRouter } from 'next/navigation';
import { toast } from 'sonner';

import DatePicker from "@/components/form/date-picker";
import ComponentCard from "@/components/common/ComponentCard";
import Form from "@/components/form/Form";
import Label from "@/components/form/Label";
import Input from "@/components/form/input/InputField";
import Select from "@/components/form/Select";
import Radio from "@/components/form/input/Radio";
import Button from "@/components/ui/button/Button";
import { generateClient } from 'aws-amplify/data'
import { Schema } from '@data-schema'


const client = generateClient<Schema>()

export type Account = Schema["Account"]['type'];

export default function AccountForm({ account }: { account?: Account }) {

  const router = useRouter();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<Partial<Account>>({
    defaultValues: account,
  });

  const save = async (data: Partial<Account>) => {
    try {
      if (account?.number) {
        await client.models.Account.update({
          number: account.number,
          ...data,
        });
      } else {
        await client.models.Account.create(data as Account);
      }
      toast.success('Account saved');
    } catch (err) {
      let errMessage = 'Error saving Account';
      if (err instanceof Error) {
        console.log("Form error:" + err.message);
        errMessage = 'Error saving Account: ' + err.message;
      }
      toast.error(errMessage);
    }
  };

  // const [selectedOption, setSelectedOption] = useState<string>("Free");

  const optionsGender = [
    { value: "male", label: "Male" },
    { value: "female", label: "Female" },
    { value: "other", label: "Others" },
  ];
  const categoryOptions = [
    { value: "cate1", label: "Category 1" },
    { value: "cate2", label: "Category 2" },
    { value: "cate3", label: "Category 3" },
  ];
  const country = [
    { value: "bd", label: "Bangladesh" },
    { value: "usa", label: "United States" },
    { value: "canada", label: "Canada" },
  ];
  const handleSelectGender = (value: string) => {
    console.log("Selected value:", value);
  };

  const handleRadioChange = (value: string) => {
    // setSelectedOption(value);
    console.log("Selected:", value);
  };

  return (
    <ComponentCard title="Account">
      <Form onSubmit={handleSubmit(save)}>
        <div className="grid gap-6 sm:grid-cols-2">
          <div className="col-span-full">
            <h4 className="pb-4 text-base font-medium text-gray-800 border-b border-gray-200 dark:border-gray-800 dark:text-white/90">
              Personal Info
            </h4>
          </div>
          <div>
            <Label htmlFor="firstName">First Name</Label>
            <Input
              placeholder="Enter first name"
              register={register('firstName', { required: true })}
              error={!!errors.firstName}
              hint={errors.firstName ? 'First name is required' : ''}
            />
          </div>
          <div>
            <Label htmlFor="lastName">Last Name</Label>
            <Input
              placeholder="Enter last name"
              register={register('lastName', { required: true })}
              error={!!errors.lastName}
              hint={errors.lastName ? 'Last name is required' : ''}
            />
          </div>
          <div className="col-span-2">
            <Label htmlFor="email">Gender</Label>
            <Select
              options={optionsGender}
              placeholder="Select an option"
              onChange={handleSelectGender}
              defaultValue=""
              className="bg-gray-50 dark:bg-gray-800"
            />
          </div>

          <div className="col-span-2">
            <DatePicker
              id="dob-picker"
              label="Date of Birth"
              placeholder="Select an option"
              onChange={(dates, currentDateString) => {
                // Handle your logic
                console.log({ dates, currentDateString });
              }}
            />
          </div>

          <div className="col-span-2">
            <Label htmlFor="email">Category</Label>
            <Select
              options={categoryOptions}
              placeholder="Select an option"
              onChange={handleSelectGender}
              defaultValue=""
              className="bg-gray-50 dark:bg-gray-800"
            />
          </div>
          <div className="col-span-2">
            <h4 className="pb-4 text-base font-medium text-gray-800 border-b border-gray-200 dark:border-gray-800 dark:text-white/90">
              Address
            </h4>
          </div>
          <div className="col-span-2">
            <Label htmlFor="street">Street</Label>
            <Input type="text" id="street" />
            <Input
              placeholder="Enter street and house number"
              register={register('addressLine1')}
            />
          </div>
          <div className="col-span-2">
            <Label htmlFor="street">Street</Label>
            <Input type="text" id="street" />
            <Input
              placeholder="Enter street and house number"
              register={register('addressLine1')}
            />
          </div>
          <div>
            <Label htmlFor="street">City</Label>
            <Input type="text" id="city" />
          </div>
          <div>
            <Label htmlFor="state">State</Label>
            <Input type="text" id="state" />
          </div>
          <div>
            <Label htmlFor="postCode">Post Code</Label>
            <Input type="text" id="postCode" />
          </div>
          <div>
            <Label htmlFor="email">Category</Label>
            <Select
              options={country}
              placeholder="--Select Country--"
              onChange={handleSelectGender}
              defaultValue=""
              className="bg-gray-50 dark:bg-gray-800"
            />
          </div>
          <div className="flex items-center gap-3 col-span-full">
            <Label className="m-0">Membership:</Label>
            <div className="flex flex-wrap items-center gap-4">
              <Radio
                id="Free"
                name="roleSelect"
                value="Free"
                label="Free"
                checked={true}
                // checked={selectedOption === "Free"}
                onChange={handleRadioChange}
              />
              <Radio
                id="Premium"
                name="roleSelect"
                value="Premium"
                label="Premium"
                checked={false}
                // checked={selectedOption === "Premium"}
                onChange={handleRadioChange}
              />
            </div>
          </div>
          <div className="flex gap-3">
            <Button size="sm">Save Changes</Button>
            <Button size="sm" variant="outline" onClick={() => router.back()}>
              Cancel
            </Button>
          </div>
        </div>
      </Form>
    </ComponentCard>
  );
}
