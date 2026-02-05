package com.example.swd392.repository;

import com.example.swd392.entity.GoodsReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface GoodsReceiptRepository extends JpaRepository<GoodsReceipt, Long> {
    
    Optional<GoodsReceipt> findByReceiptNumber(String receiptNumber);
    
    List<GoodsReceipt> findByStatus(String status);
    
    List<GoodsReceipt> findByVendor_VendorId(Long vendorId);
    
    List<GoodsReceipt> findByCreatedBy_UserId(Long userId);
    
    @Query("SELECT gr FROM GoodsReceipt gr WHERE gr.receiptDate BETWEEN :startDate AND :endDate ORDER BY gr.receiptDate DESC")
    List<GoodsReceipt> findByDateRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT gr FROM GoodsReceipt gr WHERE gr.status = 'Pending' ORDER BY gr.receiptDate ASC")
    List<GoodsReceipt> findPendingReceipts();
    
    @Query("SELECT gr FROM GoodsReceipt gr WHERE gr.vendor.vendorId = :vendorId AND gr.status = :status")
    List<GoodsReceipt> findByVendorAndStatus(@Param("vendorId") Long vendorId, @Param("status") String status);
}
