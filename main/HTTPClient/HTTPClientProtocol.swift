//TODO: ISOLatin1String like type for all strings? 

  //a way to @available by sdk?
protocol HTTPClient {
  init(host: String, port:Int?)
  func fetch(_ path:String)
}

//TODO: 
// protocol ClientService {}
// protocol NetworkService {}