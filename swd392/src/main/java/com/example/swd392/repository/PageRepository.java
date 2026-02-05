package com.example.swd392.repository;

import com.example.swd392.entity.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PageRepository extends JpaRepository<Page, Long> {
    
    Optional<Page> findByPageCode(String pageCode);
    
    List<Page> findByIsActiveAndIsMenuOrderByDisplayOrder(Boolean isActive, Boolean isMenu);
    
    List<Page> findByPageGroupAndIsActiveOrderByDisplayOrder(String pageGroup, Boolean isActive);
    
    List<Page> findByIsActiveOrderByDisplayOrder(Boolean isActive);
}
