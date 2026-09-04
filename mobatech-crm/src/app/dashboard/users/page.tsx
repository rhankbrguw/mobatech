import { UsersClient } from "@/components/UsersClient";

export const metadata = {
  title: "Manajemen Pengguna | Hermina CRM",
};

export default function UsersPage() {
  return <><h1 className="sr-only">{metadata.title as string}</h1><UsersClient /></>;
}
