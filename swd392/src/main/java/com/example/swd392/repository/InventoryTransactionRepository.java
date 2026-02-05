package com.example.swd392.repository;

import com.example.swd392.entity.InventoryTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface InventoryTransactionRepository extends JpaRepository<InventoryTransaction, Long> {
    
    List<InventoryTransaction> findByProduct_ProductId(Long productId);
    
    List<InventoryTransaction> findByTransactionType(String transactionType);
    
    List<InventoryTransaction> findByPerformedBy_UserId(Long userId);
    
    @Query("SELECT it FROM InventoryTransaction it WHERE it.product.productId = :productId ORDER BY it.transactionDate DESC")
    List<InventoryTransaction> findByProductIdOrderByDateDesc(@Param("productId") Long productId);
    
    @Query("SELECT it FROM InventoryTransaction it WHERE it.transactionDate BETWEEN :startDate AND :endDate ORDER BY it.transactionDate DESC")
    List<InventoryTransaction> findByDateRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT it FROM InventoryTransaction it WHERE it.referenceType = :referenceType AND it.referenceId = :referenceId")
    List<InventoryTransaction> findByReference(@Param("referenceType") String referenceType, @Param("referenceId") Long referenceId);
}
