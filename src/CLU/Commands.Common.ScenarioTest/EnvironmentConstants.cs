﻿// ----------------------------------------------------------------------------------
//
// Copyright Microsoft Corporation
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Azure.Commands.Common.ScenarioTest
{
    public static class EnvironmentConstants
    {
        public const string UsernameKey = "Username";
        public const string PasswordKey = "Password";
        public const string ServicePrincipalKey = "ServicePrincipal";
        public const string TenantKey = "TenantId";
        public const string SubscriptionKey = "SubscriptionId";
        public const string TestRunDirectory = "TestRunDirectory";
        public const string ExampleDirectory = "ExamplesDirectory";
    }
}