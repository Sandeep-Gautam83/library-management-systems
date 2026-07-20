package com.lms.repository;

import com.lms.Enum.Role;
import com.lms.entity.User;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    boolean existsByEmail(String email);

    boolean existsByRollNumber(String rollNumber);

    Optional<User> findByEmail(String email);

    Optional<User> findByRollNumber(String rollNumber);


    List<User> findByRole(Role role);

    List<User> findByRoleAndApprovedTrue(Role role);

    long countByRole(Role role);

    long countByApproved(Boolean approved);

    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.online = :isOnline, u.lastSeen = :now, u.updatedAt = :now WHERE u.id = :userId")
    void updateStatusById(@Param("userId") Long userId,
                          @Param("isOnline") Boolean isOnline,
                          @Param("now") LocalDateTime now);

    //    Optional<User> findByRegistrationNumber(String registrationNumber);
    //    List<User> findByRoleAndOnlineTrue(Role role);
    //    Optional<User> findFirstByRole(Role role);
    //    long countByOnline(Boolean online);

    /*
    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.online = :online, u.lastSeen = :lastSeen, u.updatedAt = :lastSeen WHERE u.id = :id")
    void updateOnlineAndLastSeenById(@Param("id") Long id,
                                     @Param("online") Boolean online,
                                     @Param("lastSeen") LocalDateTime lastSeen);

     */


}
