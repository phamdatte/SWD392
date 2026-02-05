package com.example.swd392.repository;

import com.example.swd392.entity.GoodsIssueItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GoodsIssueItemRepository extends JpaRepository<GoodsIssueItem, Long> {
    
    List<GoodsIssueItem> findByGoodsIssue_IssueId(Long issueId);
    
    List<GoodsIssueItem> findByProduct_ProductId(Long productId);
    
    @Query("SELECT gii FROM GoodsIssueItem gii WHERE gii.goodsIssue.issueId = :issueId")
    List<GoodsIssueItem> findItemsByIssueId(@Param("issueId") Long issueId);
}
