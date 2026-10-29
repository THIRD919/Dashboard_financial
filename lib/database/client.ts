export type QueryResult<Row=Record<string,unknown>>={rows:Row[];affectedRows?:number};
export interface SqlClient{query<Row=Record<string,unknown>>(sql:string,params?:unknown[]):Promise<QueryResult<Row>>;}
export type ReportingScope="FACULTY"|"UNIT";
