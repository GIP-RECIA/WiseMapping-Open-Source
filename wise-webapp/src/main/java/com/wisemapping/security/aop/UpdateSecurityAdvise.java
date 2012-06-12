/*
*    Copyright [2011] [wisemapping]
*
*   Licensed under WiseMapping Public License, Version 1.0 (the "License").
*   It is basically the Apache License, Version 2.0 (the "License") plus the
*   "powered by wisemapping" text requirement on every single page;
*   you may not use this file except in compliance with the License.
*   You may obtain a copy of the license at
*
*       http://www.wisemapping.org/license
*
*   Unless required by applicable law or agreed to in writing, software
*   distributed under the License is distributed on an "AS IS" BASIS,
*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*   See the License for the specific language governing permissions and
*   limitations under the License.
*/

package com.wisemapping.security.aop;

import com.wisemapping.model.CollaborationRole;
import com.wisemapping.model.User;
import com.wisemapping.model.MindMap;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.jetbrains.annotations.NotNull;

public class UpdateSecurityAdvise
        extends BaseSecurityAdvice
        implements MethodInterceptor {

    public Object invoke(MethodInvocation methodInvocation) throws Throwable {
        checkRole(methodInvocation);
        return methodInvocation.proceed();
    }

    protected boolean isAllowed(@NotNull User user, @NotNull MindMap map) {
        boolean result;
        if (map.getCreator() == null) {
            // This means that the map is new and  is an add operation.
            result = true;
        } else {
            result = getMindmapService().hasPermissions(user, map, CollaborationRole.EDITOR);
        }
        return result;
    }

    protected boolean isAllowed(User user, int mapId) {
        return getMindmapService().hasPermissions(user, mapId, CollaborationRole.EDITOR);
    }
}
