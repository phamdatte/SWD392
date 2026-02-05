package com.example.swd392.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "goods_issue_item")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GoodsIssueItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "issue_item_id")
    private Long issueItemId;
    
    @ManyToOne
    @JoinColumn(name = "issue_id", nullable = false)
    private GoodsIssue goodsIssue;
    
    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;
    
    @Column(name = "quantity", nullable = false)
    private Integer quantity;
    
    @Column(name = "unit_price", nullable = false, precision = 15, scale = 2)
    private BigDecimal unitPrice;
    
    @Column(name = "subtotal", precision = 15, scale = 2, insertable = false, updatable = false)
    private BigDecimal subtotal;  // Generated column in DB
}
