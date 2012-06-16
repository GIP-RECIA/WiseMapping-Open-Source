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

package com.wisemapping.ncontroller;


import com.wisemapping.service.InvalidUserEmailException;
import com.wisemapping.service.UserService;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class UsersController {

    @Qualifier("userService")
    @Autowired
    private UserService userService;

    @RequestMapping(value = "user/resetPassword", method = RequestMethod.GET)
    public ModelAndView showResetPasswordPage() {
        return new ModelAndView("forgotPassword");
    }

    @RequestMapping(value = "user/resetPassword", method = RequestMethod.POST)
    public ModelAndView resetPassword(@RequestParam(required = true) String email) {

        ModelAndView result;
        try {
            userService.resetPassword(email);
            result = new ModelAndView("forgotPasswordSuccess");

        } catch (InvalidUserEmailException e) {
            result = new ModelAndView("forgotPasswordError");

        }
        return result;
    }

    public void setUserService(@NotNull UserService userService) {
        this.userService = userService;
    }
}