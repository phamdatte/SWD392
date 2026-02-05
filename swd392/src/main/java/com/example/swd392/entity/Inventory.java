package com.example.swd392.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "inventory")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Inventory {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "inventory_id")
    private Long inventoryId;
    
    @OneToOne
    @JoinColumn(name = "product_id", nullable = false, unique = true)
    private Product product;
    
    @Column(name = "quantity")
    private Integer quantity = 0;
    
    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;
    
    @PreUpdate
    @PrePersist
    protected void onUpdate() {
        lastUpdated = LocalDateTime.now();
    }
}
