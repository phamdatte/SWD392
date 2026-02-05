package com.example.swd392.repository;

import com.example.swd392.entity.GoodsReceiptItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GoodsReceiptItemRepository extends JpaRepository<GoodsReceiptItem, Long> {
    
    List<GoodsReceiptItem> findByGoodsReceipt_ReceiptId(Long receiptId);
    
    List<GoodsReceiptItem> findByProduct_ProductId(Long productId);
    
    @Query("SELECT gri FROM GoodsReceiptItem gri WHERE gri.goodsReceipt.receiptId = :receiptId")
    List<GoodsReceiptItem> findItemsByReceiptId(@Param("receiptId") Long receiptId);
}
