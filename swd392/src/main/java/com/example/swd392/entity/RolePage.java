package com.example.swd392.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Entity
@Table(name = "role_page")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RolePage {
    
    @EmbeddedId
    private RolePageId id;
    
    @ManyToOne
    @MapsId("roleId")
    @JoinColumn(name = "role_id")
    private Role role;
    
    @ManyToOne
    @MapsId("pageId")
    @JoinColumn(name = "page_id")
    private Page page;
    
    @Column(name = "can_view")
    private Boolean canView = true;
    
    @Column(name = "can_create")
    private Boolean canCreate = false;
    
    @Column(name = "can_edit")
    private Boolean canEdit = false;
    
    @Column(name = "can_delete")
    private Boolean canDelete = false;
    
    @Column(name = "can_approve")
    private Boolean canApprove = false;
    
    @Embeddable
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RolePageId implements Serializable {
        @Column(name = "role_id")
        private Long roleId;
        
        @Column(name = "page_id")
        private Long pageId;
    }
}
