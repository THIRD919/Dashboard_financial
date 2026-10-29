import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Vet CMU Financial Dashboard Prototype",
  description: "Local bilingual executive financial dashboard prototype for the Faculty of Veterinary Medicine, Chiang Mai University.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="th"><body>{children}</body></html>;
}
