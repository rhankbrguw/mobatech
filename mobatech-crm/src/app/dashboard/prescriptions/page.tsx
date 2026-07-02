/* eslint-disable react-hooks/set-state-in-effect */
/* eslint-disable @typescript-eslint/no-explicit-any */
"use client";

import { PharmacyPrescriptions } from "@/components/pharmacy/PharmacyPrescriptions";

export default function PrescriptionsPage() {
  return (
    <div className="space-y-6 animate-slide-in">
      <PharmacyPrescriptions />
    </div>
  );
}
