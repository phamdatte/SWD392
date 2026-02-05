package com.example.swd392.repository;

import com.example.swd392.entity.Vendor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VendorRepository extends JpaRepository<Vendor, Long> {
    
    Optional<Vendor> findByVendorCode(String vendorCode);
    
    List<Vendor> findByIsActive(Boolean isActive);
    
    List<Vendor> findByVendorNameContainingIgnoreCase(String vendorName);
    
    boolean existsByVendorCode(String vendorCode);
}
