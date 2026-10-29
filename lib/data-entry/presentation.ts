import type {Locale} from "../types.ts";

export function displayMoney(value:string|null|undefined,locale:Locale){
  if(value==null)return null;
  const formatted=new Intl.NumberFormat(locale==='th'?'th-TH':'en-US',{minimumFractionDigits:2,maximumFractionDigits:2}).format(Number(value));
  return locale==='th'?`${formatted} บาท`:`THB ${formatted}`;
}

export function displayRatio(value:string|null|undefined,locale:Locale){
  if(value==null)return null;
  return `${Number(value).toFixed(2)}${locale==='th'?' เท่า':'x'}`;
}
