package com.example.swd392.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "inventory_transaction")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class InventoryTransaction {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "transaction_id")
    private Long transactionId;
    
    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;
    
    @Column(name = "transaction_type", nullable = false, length = 20)
    private String transactionType;  // Receipt, Issue
    
    @Column(name = "quantity", nullable = false)
    private Integer quantity;  // Positive for Receipt, Negative for Issue
    
    @Column(name = "quantity_before", nullable = false)
    private Integer quantityBefore;
    
    @Column(name = "quantity_after", nullable = false)
    private Integer quantityAfter;
    
    @Column(name = "reference_id")
    private Long referenceId;
    
    @Column(name = "reference_type", length = 20)
    private String referenceType;  // GoodsReceipt, GoodsIssue
    
    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;
    
    @ManyToOne
    @JoinColumn(name = "performed_by", nullable = false)
    private User performedBy;
    
    @CreationTimestamp
    @Column(name = "transaction_date", updatable = false)
    private LocalDateTime transactionDate;
}
