# YCYNetworkManager

## YCYNetworkManager是什么？
YCYNetworkManager是基于AFNetworking 的iOS网络库。

在做项目时，我们基本都在是在AFNetworking上做二次开发，加入自己项目的特性，封装成请求API层。

### 主要功能
* 缓存get请求（参数设定一个不为0的数字）

### to do list
* 串行请求控制
* 并发请求控制
* 设置参数（每个请求都带上某些参数）
* 取消正在发送的请求

### 发送get请求
```objc
//get请求
- (void)getDataFromServerAndBlock:(void (^)(id data, NSError *error))block
{
self.clientManger = [[YCYClientNetworkManager alloc] init];

NSDictionary *param =@{@"test":@1};
//缓存时间以秒为单位
[self.clientManger Get:@"http://httpbin.org/get" withParams:param withCacheDuration:10 andBlock:^(id data, NSError *error) {
block(data, error);
}];
}
```