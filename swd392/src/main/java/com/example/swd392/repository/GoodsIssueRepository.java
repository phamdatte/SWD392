package com.example.swd392.repository;

import com.example.swd392.entity.GoodsIssue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface GoodsIssueRepository extends JpaRepository<GoodsIssue, Long> {
    
    Optional<GoodsIssue> findByIssueNumber(String issueNumber);
    
    List<GoodsIssue> findByStatus(String status);
    
    List<GoodsIssue> findByCreatedBy_UserId(Long userId);
    
    List<GoodsIssue> findByCustomerNameContainingIgnoreCase(String customerName);
    
    @Query("SELECT gi FROM GoodsIssue gi WHERE gi.issueDate BETWEEN :startDate AND :endDate ORDER BY gi.issueDate DESC")
    List<GoodsIssue> findByDateRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT gi FROM GoodsIssue gi WHERE gi.status = 'Pending' ORDER BY gi.issueDate ASC")
    List<GoodsIssue> findPendingIssues();
}
