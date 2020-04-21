//
//  Item.h
//  ceshi
//
//  Created by zipeng an  on 2020/4/20.
//  Copyright © 2020 A. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//{\"id\":\"1585362112524a16c599771f2e3a0\",\"stepDefineId\":\"1585362112524a16c599771f2e3a0\",\"row\":3,\"column\":3,\"approverId\":\"a16c599771f2e3a0\",\"parentId\":\"1568507542988a16c599771f2e3a0\",\"approverName\":\"林俊杰\"}]
@interface Item : NSObject
@property(nonatomic,strong) NSString * parentId;
@property(nonatomic,strong) NSString * id;
@property(nonatomic,strong) NSString * approverName;
@property(nonatomic,strong) NSString * stepDefineId;
@property(nonatomic,assign) int row;
@property(nonatomic,assign) int column;
@property(nonatomic,strong) NSString * approverId;


@end

NS_ASSUME_NONNULL_END
