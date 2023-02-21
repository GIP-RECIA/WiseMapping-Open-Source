package com.wisemapping.security.cas;

import com.wisemapping.model.User;
import com.wisemapping.security.UserDetails;
import org.jetbrains.annotations.NotNull;

public class CasUserDetails extends UserDetails {

    public CasUserDetails(@NotNull User user, boolean isAdmin) {
        super(user, isAdmin);
    }

    @Override
    public String getUsername() {
        return super.getUser().getCasUid();
    }

}
