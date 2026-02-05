package com.example.swd392.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.Set;

@Entity
@Table(name = "page")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Page {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "page_id")
    private Long pageId;
    
    @Column(name = "page_code", nullable = false, unique = true, length = 50)
    private String pageCode;
    
    @Column(name = "page_name", nullable = false, length = 100)
    private String pageName;
    
    @Column(name = "page_url", length = 200)
    private String pageUrl;
    
    @Column(name = "page_group", length = 50)
    private String pageGroup;
    
    @Column(name = "icon", length = 50)
    private String icon;
    
    @Column(name = "display_order")
    private Integer displayOrder = 0;
    
    @Column(name = "is_menu")
    private Boolean isMenu = true;
    
    @Column(name = "is_active")
    private Boolean isActive = true;
    
    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @OneToMany(mappedBy = "page")
    private Set<RolePage> rolePages;
}
