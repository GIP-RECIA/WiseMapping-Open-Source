package com.wisemapping.security.cas;

import com.wisemapping.exceptions.WiseMappingException;
import com.wisemapping.model.AuthenticationType;
import com.wisemapping.model.User;
import com.wisemapping.service.UserService;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.security.cas.authentication.CasAssertionAuthenticationToken;
import org.springframework.security.core.userdetails.AuthenticationUserDetailsService;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.Calendar;

public class CasUserDetailsService implements AuthenticationUserDetailsService<CasAssertionAuthenticationToken> {

    private UserService userService;
    private String ldapAttributeEmail;
    private String ldapAttributeFirstName;
    private String ldapAttributeLastName;

    public CasUserDetailsService() {
    }

    public UserService getUserService() {
        return userService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public String getLdapAttributeEmail() {
        return ldapAttributeEmail;
    }

    public void setLdapAttributeEmail(String ldapAttributeEmail) {
        this.ldapAttributeEmail = ldapAttributeEmail;
    }

    public String getLdapAttributeFirstName() {
        return ldapAttributeFirstName;
    }

    public void setLdapAttributeFirstName(String ldapAttributeFirstName) {
        this.ldapAttributeFirstName = ldapAttributeFirstName;
    }

    public String getLdapAttributeLastName() {
        return ldapAttributeLastName;
    }

    public void setLdapAttributeLastName(String ldapAttributeLastName) {
        this.ldapAttributeLastName = ldapAttributeLastName;
    }

    @Override
    public UserDetails loadUserDetails(CasAssertionAuthenticationToken token) throws UsernameNotFoundException {
        String casUid = token.getPrincipal().toString();
        User user = userService.getUserByCasUid(casUid);
        if (user == null) {
            user = createUser(casUid);
        }

        return new CasUserDetails(user, false);
    }

    private User createUser(String casUid) {
        // TODO : Get user info from LDAP
        DirContextOperations userData = null;

        User user = new User();
        user.setCasUid(casUid);
        user.setEmail(userData.getStringAttribute(ldapAttributeEmail));
        user.setFirstname(userData.getStringAttribute(ldapAttributeFirstName));
        user.setLastname(userData.getStringAttribute(ldapAttributeLastName));
        user.setPassword("");
        user.setActivationDate(Calendar.getInstance());

        try {
            user.setAuthenticationType(AuthenticationType.CAS);
            user = userService.createUser(user, false, false);
        } catch (WiseMappingException e) {
            throw new IllegalStateException(e);
        }

        return user;
    }

}
