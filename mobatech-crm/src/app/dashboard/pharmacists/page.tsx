import { PharmacistsClient } from "@/components/PharmacistsClient";

export const metadata = {
  title: "Manajemen Apoteker | Hermina CRM",
};

export default function PharmacistsPage() {
  return (
    <>
      <h1 className="sr-only">{metadata.title}</h1>
      <PharmacistsClient />
    </>
  );
}
