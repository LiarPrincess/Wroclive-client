//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import Result

typealias ApiResponse<Data> = Observable<Result<Data, ApiError>>
