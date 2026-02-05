package com.example.swd392.repository;

import com.example.swd392.entity.RolePage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RolePageRepository extends JpaRepository<RolePage, RolePage.RolePageId> {
    
    List<RolePage> findByRole_RoleId(Long roleId);
    
    List<RolePage> findByPage_PageId(Long pageId);
    
    Optional<RolePage> findByRole_RoleIdAndPage_PageId(Long roleId, Long pageId);
    
    @Query("SELECT rp FROM RolePage rp WHERE rp.role.roleId = :roleId AND rp.canView = true")
    List<RolePage> findAccessiblePagesByRoleId(@Param("roleId") Long roleId);
    
    @Query("SELECT rp FROM RolePage rp WHERE rp.role.roleId = :roleId AND rp.page.pageCode = :pageCode")
    Optional<RolePage> findByRoleIdAndPageCode(@Param("roleId") Long roleId, @Param("pageCode") String pageCode);
}
