#import "RNAuthorizeNet.h"
@import AuthorizeNetAccept;

@implementation RNAuthorizeNet

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

static NSString *const LOGIN_ID = @"LOGIN_ID";
static NSString *const CLIENT_KEY = @"CLIENT_KEY";
static NSString *const CARD_NO = @"CARD_NO";
static NSString *const EXPIRATION_MONTH = @"EXPIRATION_MONTH";
static NSString *const EXPIRATION_YEAR = @"EXPIRATION_YEAR";
static NSString *const CVV_NO = @"CVV_NO";
static NSString *const ZIP_CODE = @"ZIP_CODE";
static NSString *const ACCOUNT_HOLDER_NAME = @"ACCOUNT_HOLDER_NAME";
static NSString *const ACCOUNT_HOLDER_EMAIL = @"ACCOUNT_HOLDER_EMAIL";
static NSString *const DATA_DESCRIPTOR = @"DATA_DESCRIPTOR";
static NSString *const DATA_VALUE = @"DATA_VALUE";
static NSString *const ERROR_CODE = @"ERROR_CODE";
static NSString *const ERROR_TEXT = @"ERROR_TEXT";

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getTokenWithRequestForCard:(NSDictionary *)cardValues isProduction:(BOOL)isProduction resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    AcceptSDKHandler *handler = [[AcceptSDKHandler alloc] initWithEnvironment:isProduction ? AcceptSDKEnvironmentENV_LIVE : AcceptSDKEnvironmentENV_TEST];
    AcceptSDKRequest *request = [[AcceptSDKRequest alloc] init];
    request.merchantAuthentication.name = [cardValues valueForKey:LOGIN_ID];
    request.merchantAuthentication.clientKey = [cardValues valueForKey:CLIENT_KEY];

    request.securePaymentContainerRequest.webCheckOutDataType.token.cardNumber = [cardValues valueForKey:CARD_NO];
    request.securePaymentContainerRequest.webCheckOutDataType.token.expirationMonth = [cardValues valueForKey:EXPIRATION_MONTH];
    request.securePaymentContainerRequest.webCheckOutDataType.token.expirationYear = [cardValues valueForKey:EXPIRATION_YEAR];
    request.securePaymentContainerRequest.webCheckOutDataType.token.cardCode = [cardValues valueForKey:CVV_NO];

    [handler getTokenWithRequest:request successHandler:^(AcceptSDKTokenResponse * _Nonnull token) {
        NSDictionary *responsDict = @{DATA_DESCRIPTOR:token.getOpaqueData.getDataDescriptor, DATA_VALUE:token.getOpaqueData.getDataValue};
        resolve(responsDict);
    } failureHandler:^(AcceptSDKErrorResponse * _Nonnull error) {
      
        NSLog(@"Error occurred: %@ - %@", error.getMessages.getResultCode, error.getMessages.getMessages[0].getCode);
        NSString *errorCode = error.getMessages.getMessages[0].getCode;
        NSString *errorText = error.getMessages.getMessages[0].getText;

        NSLog(@"Error occurred: %@ - %@", errorCode, errorText);

        NSDictionary *errorDict = @{
            @"ERROR_CODE": errorCode,
            @"ERROR_TEXT": errorText
        };

        reject(errorCode, errorText, nil);
    }];
}

@end

