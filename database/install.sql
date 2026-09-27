-- TrainTote demo database schema
-- Schema only. No account or application rows are included.

-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_remember_tokens`
--

CREATE TABLE `auth_remember_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `selector` char(24) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment`
--

CREATE TABLE `equipment` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `reporting_marks` varchar(20) NOT NULL,
  `road_number` varchar(20) NOT NULL,
  `road_name` varchar(100) DEFAULT NULL,
  `equipment_class` varchar(50) DEFAULT NULL,
  `equipment_type` varchar(50) DEFAULT NULL,
  `prototype` varchar(255) DEFAULT NULL,
  `service` varchar(100) DEFAULT NULL,
  `length_ft` varchar(20) DEFAULT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `color` varchar(100) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `photo_filename` varchar(255) DEFAULT NULL,
  `cutout_filename` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `scale` varchar(20) DEFAULT 'HO',
  `load_status` varchar(20) DEFAULT 'Empty',
  `temp_photo_filename` varchar(255) DEFAULT NULL,
  `seed_data` tinyint(1) NOT NULL DEFAULT 0,
  `current_industry_id` int(11) DEFAULT NULL,
  `current_track` varchar(255) DEFAULT NULL,
  `current_waybill_id` int(11) DEFAULT NULL,
  `operations_service` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `equipment`
--


-- --------------------------------------------------------

--
-- Table structure for table `industries`
--

CREATE TABLE `industries` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `industry_name` varchar(255) NOT NULL,
  `industry_type` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `track_capacity` int(11) DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `notes` text DEFAULT NULL,
  `photo_filename` varchar(255) DEFAULT NULL,
  `cutout_filename` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `seed_data` tinyint(1) NOT NULL DEFAULT 0,
  `assigned_job_id` int(11) DEFAULT NULL,
  `receives_services` text DEFAULT NULL,
  `ships_services` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `industries`
--


-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `job_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `origin_industry_id` int(11) DEFAULT NULL,
  `destination_industry_id` int(11) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `job_type` varchar(20) NOT NULL DEFAULT 'system',
  `assigned_equipment_id` int(11) DEFAULT NULL,
  `custom_job_type` varchar(100) DEFAULT NULL,
  `home_industry_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `jobs`
--


-- --------------------------------------------------------

--
-- Table structure for table `job_cars`
--

CREATE TABLE `job_cars` (
  `id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `waybill_id` int(11) NOT NULL,
  `from_industry_id` int(11) DEFAULT NULL,
  `to_industry_id` int(11) DEFAULT NULL,
  `move_type` varchar(50) NOT NULL DEFAULT 'setout',
  `sequence_num` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_industries`
--

CREATE TABLE `job_industries` (
  `id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL,
  `industry_id` int(11) NOT NULL,
  `sequence_number` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `job_industries`
--


-- --------------------------------------------------------

--
-- Table structure for table `job_locomotives`
--

CREATE TABLE `job_locomotives` (
  `id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `position` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `job_locomotives`
--


-- --------------------------------------------------------

--
-- Table structure for table `job_operation_profiles`
--

CREATE TABLE `job_operation_profiles` (
  `job_id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `work_scope` enum('entire_railroad','selected_route') NOT NULL DEFAULT 'entire_railroad',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_route_stops`
--

CREATE TABLE `job_route_stops` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL,
  `industry_id` int(11) DEFAULT NULL,
  `operating_area` varchar(255) DEFAULT NULL,
  `sequence_number` int(10) UNSIGNED NOT NULL,
  `exchange_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `outbound_load_status` enum('Any','Loaded','Empty') NOT NULL DEFAULT 'Any',
  `inbound_load_status` enum('Any','Loaded','Empty') NOT NULL DEFAULT 'Any',
  `pull_destination_mode` enum('operating_base','yard','staging_interchange','selected_location','next_compatible') NOT NULL DEFAULT 'yard',
  `pull_destination_industry_id` int(11) DEFAULT NULL,
  `replacement_source_mode` enum('operating_base','starting_cars','prepared_cut','staged_group','selected_location') NOT NULL DEFAULT 'starting_cars',
  `replacement_source_industry_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operating_sessions`
--

CREATE TABLE `operating_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `created_by_user_id` int(11) NOT NULL,
  `session_number` varchar(16) NOT NULL,
  `session_name` varchar(120) DEFAULT NULL,
  `operating_date` date NOT NULL,
  `status` enum('draft','ready','in_progress','completed','cancelled') NOT NULL DEFAULT 'draft',
  `notes` text DEFAULT NULL,
  `yardmaster_name` varchar(120) DEFAULT NULL,
  `fast_clock_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `fast_clock_running` tinyint(1) NOT NULL DEFAULT 0,
  `fast_clock_start_minutes` smallint(5) UNSIGNED NOT NULL DEFAULT 480,
  `fast_clock_ratio` tinyint(3) UNSIGNED NOT NULL DEFAULT 4,
  `fast_clock_base_model_seconds` int(10) UNSIGNED NOT NULL DEFAULT 28800,
  `fast_clock_base_real_at` datetime DEFAULT NULL,
  `fast_clock_last_sync_at` datetime DEFAULT NULL,
  `fast_clock_started_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `dispatcher_enabled` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operations_service_options`
--

CREATE TABLE `operations_service_options` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) DEFAULT NULL,
  `equipment_type` varchar(100) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `operations_service_options`
--


-- --------------------------------------------------------

--
-- Table structure for table `operation_assignments`
--

CREATE TABLE `operation_assignments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `job_template_id` int(11) DEFAULT NULL,
  `assignment_number` varchar(24) NOT NULL,
  `unit_identifier` varchar(24) DEFAULT NULL,
  `sequence_number` int(10) UNSIGNED NOT NULL,
  `title_snapshot` varchar(120) NOT NULL,
  `type_snapshot` varchar(64) NOT NULL,
  `description_snapshot` text DEFAULT NULL,
  `operating_pattern` varchar(64) NOT NULL,
  `status` enum('draft','ready','waiting','in_progress','needs_review','completed','cancelled','aborted') NOT NULL DEFAULT 'draft',
  `operating_base_industry_id` int(11) DEFAULT NULL,
  `starting_track` varchar(120) DEFAULT NULL,
  `start_method` enum('locomotives_only','coupled_selected','prepared_cut','manual','auto_build','inherit') NOT NULL DEFAULT 'locomotives_only',
  `prepared_cut_id` bigint(20) UNSIGNED DEFAULT NULL,
  `requested_car_count` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `prepared_cut_car_count` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `difficulty` enum('easy','medium','hard') NOT NULL DEFAULT 'medium',
  `crew_name` varchar(120) DEFAULT NULL,
  `engineer_name` varchar(120) DEFAULT NULL,
  `conductor_name` varchar(120) DEFAULT NULL,
  `brakeman_names` varchar(255) DEFAULT NULL,
  `predecessor_assignment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `dependency_mode` enum('locomotives','cars','entire_train','continue') DEFAULT NULL,
  `end_plan` varchar(64) NOT NULL DEFAULT 'return_origin',
  `end_industry_id` int(11) DEFAULT NULL,
  `end_track` varchar(120) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `approved_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `dispatcher_status` enum('not_started','working','delayed') NOT NULL DEFAULT 'not_started',
  `dispatcher_note` text DEFAULT NULL,
  `dispatcher_crew_message` varchar(255) DEFAULT NULL,
  `dispatcher_updated_at` datetime DEFAULT NULL,
  `dispatcher_updated_by_user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_assignment_locomotives`
--

CREATE TABLE `operation_assignment_locomotives` (
  `assignment_id` bigint(20) UNSIGNED NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `position` int(10) UNSIGNED NOT NULL,
  `source` enum('selected','inherited') NOT NULL DEFAULT 'selected',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_assignment_starting_cars`
--

CREATE TABLE `operation_assignment_starting_cars` (
  `assignment_id` bigint(20) UNSIGNED NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `position` int(10) UNSIGNED NOT NULL,
  `source_type` enum('prepared_cut','selected','auto_built','inherited') NOT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_log`
--

CREATE TABLE `operation_log` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `completed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `old_industry_id` int(11) DEFAULT NULL,
  `new_industry_id` int(11) DEFAULT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `old_cycle` tinyint(4) DEFAULT NULL,
  `new_cycle` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `operation_log`
--


-- --------------------------------------------------------

--
-- Table structure for table `operation_module_settings`
--

CREATE TABLE `operation_module_settings` (
  `railroad_id` int(11) NOT NULL,
  `module_key` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  `updated_by_user_id` int(11) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_railroad_roles`
--

CREATE TABLE `operation_railroad_roles` (
  `railroad_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('dispatcher','yardmaster') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_repairs`
--

CREATE TABLE `operation_repairs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `source_move_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('awaiting_repair','in_repair','ready_for_service','closed') NOT NULL DEFAULT 'awaiting_repair',
  `reason_code` varchar(64) NOT NULL DEFAULT 'bad_order',
  `original_notes` varchar(255) DEFAULT NULL,
  `reported_at` datetime NOT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `equipment_active_before` tinyint(1) NOT NULL DEFAULT 1,
  `service_state_applied` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `closed_at` datetime DEFAULT NULL,
  `open_equipment_id` int(11) GENERATED ALWAYS AS (case when `status` in ('awaiting_repair','in_repair','ready_for_service') then `equipment_id` else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_repair_history`
--

CREATE TABLE `operation_repair_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `repair_id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `event_type` enum('reported','incident','status_change','note') NOT NULL,
  `previous_status` varchar(32) DEFAULT NULL,
  `new_status` varchar(32) NOT NULL,
  `note` text DEFAULT NULL,
  `source_move_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_session_invites`
--

CREATE TABLE `operation_session_invites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `token_hash` char(64) NOT NULL,
  `invite_type` enum('email','qr') NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `assignment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by_user_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `claimed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_session_participants`
--

CREATE TABLE `operation_session_participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invite_id` bigint(20) UNSIGNED NOT NULL,
  `display_name` varchar(120) NOT NULL,
  `access_hash` char(64) NOT NULL,
  `status` enum('pending','approved','revoked') NOT NULL DEFAULT 'pending',
  `assignment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `joined_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_session_roles`
--

CREATE TABLE `operation_session_roles` (
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('yardmaster') NOT NULL,
  `assigned_by_user_id` int(11) DEFAULT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_switch_lists`
--

CREATE TABLE `operation_switch_lists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `assignment_id` bigint(20) UNSIGNED NOT NULL,
  `switch_list_number` varchar(24) NOT NULL,
  `revision_number` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `status` enum('draft','approved','in_progress','completed','cancelled','needs_review','superseded') NOT NULL DEFAULT 'draft',
  `generated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `approved_at` datetime DEFAULT NULL,
  `printed_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `generated_by_user_id` int(11) NOT NULL,
  `approved_by_user_id` int(11) DEFAULT NULL,
  `planned_move_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `moved_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `not_moved_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `diagnostic_summary` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_switch_list_moves`
--

CREATE TABLE `operation_switch_list_moves` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `switch_list_id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `sequence_number` int(10) UNSIGNED NOT NULL,
  `movement_group` varchar(36) NOT NULL,
  `equipment_id` int(11) DEFAULT NULL,
  `reporting_marks_snapshot` varchar(24) DEFAULT NULL,
  `road_number_snapshot` varchar(24) DEFAULT NULL,
  `equipment_type_snapshot` varchar(80) DEFAULT NULL,
  `service_snapshot` varchar(120) DEFAULT NULL,
  `photo_filename_snapshot` varchar(255) DEFAULT NULL,
  `original_load_status` varchar(64) DEFAULT NULL,
  `planned_load_status` varchar(64) DEFAULT NULL,
  `origin_industry_id` int(11) DEFAULT NULL,
  `origin_name_snapshot` varchar(120) DEFAULT NULL,
  `origin_track` varchar(120) DEFAULT NULL,
  `destination_industry_id` int(11) DEFAULT NULL,
  `destination_name_snapshot` varchar(120) DEFAULT NULL,
  `destination_track` varchar(120) DEFAULT NULL,
  `action` varchar(32) NOT NULL,
  `instruction` varchar(255) NOT NULL,
  `work_location` varchar(120) DEFAULT NULL,
  `progress_complete` tinyint(1) NOT NULL DEFAULT 0,
  `actual_outcome` enum('pending','moved','not_moved') NOT NULL DEFAULT 'pending',
  `actual_industry_id` int(11) DEFAULT NULL,
  `actual_track` varchar(120) DEFAULT NULL,
  `actual_load_status` varchar(64) DEFAULT NULL,
  `exception_reason_code` varchar(64) DEFAULT NULL,
  `exception_notes` varchar(255) DEFAULT NULL,
  `progress_updated_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_switch_moves`
--

CREATE TABLE `operation_switch_moves` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `switch_session_id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `move_key` varchar(64) NOT NULL,
  `outcome` enum('moved','not_moved') NOT NULL,
  `reason_code` varchar(64) DEFAULT NULL,
  `reason_notes` varchar(255) DEFAULT NULL,
  `old_industry_id` int(11) DEFAULT NULL,
  `new_industry_id` int(11) DEFAULT NULL,
  `old_track` varchar(255) DEFAULT NULL,
  `new_track` varchar(255) DEFAULT NULL,
  `old_load_status` varchar(64) DEFAULT NULL,
  `new_load_status` varchar(64) DEFAULT NULL,
  `completed_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_switch_sessions`
--

CREATE TABLE `operation_switch_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `source_type` varchar(32) NOT NULL,
  `source_key` varchar(64) NOT NULL,
  `moved_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skipped_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `completed_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_yard_assignments`
--

CREATE TABLE `operation_yard_assignments` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `yard_industry_id` int(11) NOT NULL,
  `planned_track` varchar(120) DEFAULT NULL,
  `classification_group` varchar(120) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `updated_by_user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operation_yard_history`
--

CREATE TABLE `operation_yard_history` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `equipment_id` int(11) DEFAULT NULL,
  `event_type` enum('assigned','moved','cleared','role_assigned','role_cleared') NOT NULL,
  `from_yard_industry_id` int(11) DEFAULT NULL,
  `to_yard_industry_id` int(11) DEFAULT NULL,
  `detail` varchar(255) DEFAULT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prepared_cuts`
--

CREATE TABLE `prepared_cuts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `cut_number` varchar(20) NOT NULL,
  `name` varchar(120) NOT NULL,
  `current_industry_id` int(11) NOT NULL,
  `current_track` varchar(120) NOT NULL,
  `intended_job_template_id` int(11) DEFAULT NULL,
  `status` enum('ready','assigned','in_use','released','dissolved') NOT NULL DEFAULT 'ready',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prepared_cut_cars`
--

CREATE TABLE `prepared_cut_cars` (
  `prepared_cut_id` bigint(20) UNSIGNED NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `position` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `railroads`
--

CREATE TABLE `railroads` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `era` varchar(50) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `operating_style` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_default` tinyint(1) DEFAULT 1,
  `seed_data` tinyint(1) NOT NULL DEFAULT 0,
  `operations_dispatcher_enabled` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `railroads`
--


-- --------------------------------------------------------

--
-- Table structure for table `repair_queue`
--

CREATE TABLE `repair_queue` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `issue_type` varchar(100) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'open',
  `opened_at` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `demo_user` tinyint(1) NOT NULL DEFAULT 0,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--


-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE `user_settings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `theme` varchar(50) DEFAULT 'light',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `waybills`
--

CREATE TABLE `waybills` (
  `id` int(11) NOT NULL,
  `railroad_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `origin_industry_id` int(11) DEFAULT NULL,
  `destination_industry_id` int(11) DEFAULT NULL,
  `commodity` varchar(255) DEFAULT NULL,
  `route` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `routing` varchar(255) DEFAULT NULL,
  `current_cycle` tinyint(4) NOT NULL DEFAULT 1,
  `cycle_count` tinyint(4) NOT NULL DEFAULT 4,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `seed_data` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `waybills`
--


-- --------------------------------------------------------

--
-- Table structure for table `waybill_cycles`
--

CREATE TABLE `waybill_cycles` (
  `id` int(11) NOT NULL,
  `waybill_id` int(11) NOT NULL,
  `cycle_number` tinyint(4) NOT NULL,
  `origin_industry_id` int(11) DEFAULT NULL,
  `destination_industry_id` int(11) DEFAULT NULL,
  `commodity` varchar(255) DEFAULT NULL,
  `route` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `seed_data` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `waybill_cycles`
--


--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_remember_tokens`
--
ALTER TABLE `auth_remember_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_auth_remember_selector` (`selector`),
  ADD KEY `idx_auth_remember_user_expiry` (`user_id`,`expires_at`);

--
-- Indexes for table `equipment`
--
ALTER TABLE `equipment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_equipment_railroad` (`railroad_id`),
  ADD KEY `idx_equipment_railroad` (`railroad_id`);

--
-- Indexes for table `industries`
--
ALTER TABLE `industries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_industries_railroad` (`railroad_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_cars`
--
ALTER TABLE `job_cars`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_industries`
--
ALTER TABLE `job_industries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `job_id` (`job_id`),
  ADD KEY `industry_id` (`industry_id`);

--
-- Indexes for table `job_locomotives`
--
ALTER TABLE `job_locomotives`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_operation_profiles`
--
ALTER TABLE `job_operation_profiles`
  ADD PRIMARY KEY (`job_id`),
  ADD KEY `idx_job_operation_profile_railroad` (`railroad_id`);

--
-- Indexes for table `job_route_stops`
--
ALTER TABLE `job_route_stops`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_job_route_stop_sequence` (`job_id`,`sequence_number`),
  ADD UNIQUE KEY `uq_job_route_stop_industry` (`job_id`,`industry_id`),
  ADD UNIQUE KEY `uq_job_route_stop_area` (`job_id`,`operating_area`),
  ADD KEY `idx_job_route_stop_railroad` (`railroad_id`,`job_id`);

--
-- Indexes for table `operating_sessions`
--
ALTER TABLE `operating_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_operating_session_number` (`railroad_id`,`session_number`),
  ADD KEY `idx_operating_sessions_status` (`railroad_id`,`status`,`operating_date`);

--
-- Indexes for table `operations_service_options`
--
ALTER TABLE `operations_service_options`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `operation_assignments`
--
ALTER TABLE `operation_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_operation_assignment_number` (`railroad_id`,`assignment_number`),
  ADD UNIQUE KEY `uq_operation_assignment_sequence` (`session_id`,`sequence_number`),
  ADD KEY `idx_operation_assignment_status` (`railroad_id`,`status`),
  ADD KEY `fk_operation_assignment_predecessor` (`predecessor_assignment_id`);

--
-- Indexes for table `operation_assignment_locomotives`
--
ALTER TABLE `operation_assignment_locomotives`
  ADD PRIMARY KEY (`assignment_id`,`equipment_id`),
  ADD KEY `idx_assignment_locomotive_equipment` (`equipment_id`);

--
-- Indexes for table `operation_assignment_starting_cars`
--
ALTER TABLE `operation_assignment_starting_cars`
  ADD PRIMARY KEY (`assignment_id`,`equipment_id`),
  ADD KEY `idx_assignment_starting_car_equipment` (`equipment_id`);

--
-- Indexes for table `operation_log`
--
ALTER TABLE `operation_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `operation_module_settings`
--
ALTER TABLE `operation_module_settings`
  ADD PRIMARY KEY (`railroad_id`,`module_key`),
  ADD KEY `idx_operation_module_enabled` (`railroad_id`,`enabled`);

--
-- Indexes for table `operation_railroad_roles`
--
ALTER TABLE `operation_railroad_roles`
  ADD PRIMARY KEY (`railroad_id`,`user_id`,`role`),
  ADD KEY `idx_operation_role_user` (`user_id`,`railroad_id`);

--
-- Indexes for table `operation_repairs`
--
ALTER TABLE `operation_repairs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_operation_repair_source_move` (`source_move_id`),
  ADD UNIQUE KEY `uq_operation_repair_open_equipment` (`railroad_id`,`open_equipment_id`),
  ADD KEY `idx_operation_repairs_status` (`railroad_id`,`status`,`reported_at`),
  ADD KEY `idx_operation_repairs_equipment` (`railroad_id`,`equipment_id`);

--
-- Indexes for table `operation_repair_history`
--
ALTER TABLE `operation_repair_history`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_operation_repair_history_incident` (`repair_id`,`event_type`,`source_move_id`),
  ADD KEY `idx_operation_repair_history_repair` (`repair_id`,`created_at`),
  ADD KEY `idx_operation_repair_history_scope` (`railroad_id`,`repair_id`);

--
-- Indexes for table `operation_session_invites`
--
ALTER TABLE `operation_session_invites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_session_invite_token` (`token_hash`),
  ADD KEY `idx_session_invite_created` (`session_id`,`created_at`);

--
-- Indexes for table `operation_session_participants`
--
ALTER TABLE `operation_session_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_session_participant_access` (`access_hash`),
  ADD KEY `idx_session_participant_invite` (`invite_id`);

--
-- Indexes for table `operation_session_roles`
--
ALTER TABLE `operation_session_roles`
  ADD PRIMARY KEY (`session_id`,`role`),
  ADD KEY `idx_operation_session_role_user` (`user_id`,`railroad_id`,`role`),
  ADD KEY `fk_operation_session_role_railroad` (`railroad_id`);

--
-- Indexes for table `operation_switch_lists`
--
ALTER TABLE `operation_switch_lists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_operation_switch_list_revision` (`assignment_id`,`revision_number`),
  ADD KEY `idx_operation_switch_list_status` (`railroad_id`,`status`,`updated_at`),
  ADD KEY `fk_operation_switch_list_session` (`session_id`);

--
-- Indexes for table `operation_switch_list_moves`
--
ALTER TABLE `operation_switch_list_moves`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_switch_list_move_sequence` (`switch_list_id`,`sequence_number`),
  ADD KEY `idx_switch_list_move_equipment` (`railroad_id`,`equipment_id`);

--
-- Indexes for table `operation_switch_moves`
--
ALTER TABLE `operation_switch_moves`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_operation_switch_move` (`switch_session_id`,`move_key`),
  ADD KEY `idx_operation_switch_move_railroad` (`railroad_id`),
  ADD KEY `idx_operation_switch_move_equipment` (`equipment_id`);

--
-- Indexes for table `operation_switch_sessions`
--
ALTER TABLE `operation_switch_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_operation_switch_source` (`railroad_id`,`source_type`,`source_key`),
  ADD KEY `idx_operation_switch_railroad_completed` (`railroad_id`,`completed_at`),
  ADD KEY `idx_operation_switch_user` (`user_id`);

--
-- Indexes for table `operation_yard_assignments`
--
ALTER TABLE `operation_yard_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_yard_assignment_session_equipment` (`session_id`,`equipment_id`),
  ADD KEY `idx_yard_assignment_scope` (`railroad_id`,`session_id`,`yard_industry_id`),
  ADD KEY `fk_yard_assignment_equipment` (`equipment_id`),
  ADD KEY `fk_yard_assignment_industry` (`yard_industry_id`);

--
-- Indexes for table `operation_yard_history`
--
ALTER TABLE `operation_yard_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_yard_history_session` (`railroad_id`,`session_id`,`created_at`),
  ADD KEY `fk_yard_history_session` (`session_id`),
  ADD KEY `fk_yard_history_equipment` (`equipment_id`),
  ADD KEY `fk_yard_history_from_industry` (`from_yard_industry_id`),
  ADD KEY `fk_yard_history_to_industry` (`to_yard_industry_id`);

--
-- Indexes for table `prepared_cuts`
--
ALTER TABLE `prepared_cuts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_prepared_cut_number` (`railroad_id`,`cut_number`),
  ADD KEY `idx_prepared_cut_status` (`railroad_id`,`status`);

--
-- Indexes for table `prepared_cut_cars`
--
ALTER TABLE `prepared_cut_cars`
  ADD PRIMARY KEY (`prepared_cut_id`,`equipment_id`),
  ADD KEY `idx_prepared_cut_car_equipment` (`equipment_id`);

--
-- Indexes for table `railroads`
--
ALTER TABLE `railroads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_railroad_user` (`user_id`);

--
-- Indexes for table `repair_queue`
--
ALTER TABLE `repair_queue`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_demo_user` (`demo_user`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Indexes for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_settings_user` (`user_id`);

--
-- Indexes for table `waybills`
--
ALTER TABLE `waybills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `railroad_id` (`railroad_id`),
  ADD KEY `equipment_id` (`equipment_id`),
  ADD KEY `origin_industry_id` (`origin_industry_id`),
  ADD KEY `destination_industry_id` (`destination_industry_id`),
  ADD KEY `idx_waybills_railroad` (`railroad_id`);

--
-- Indexes for table `waybill_cycles`
--
ALTER TABLE `waybill_cycles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `waybill_id` (`waybill_id`),
  ADD KEY `idx_cycles_waybill` (`waybill_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_remember_tokens`
--
ALTER TABLE `auth_remember_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `equipment`
--
ALTER TABLE `equipment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `industries`
--
ALTER TABLE `industries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `job_cars`
--
ALTER TABLE `job_cars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job_industries`
--
ALTER TABLE `job_industries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `job_locomotives`
--
ALTER TABLE `job_locomotives`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `job_route_stops`
--
ALTER TABLE `job_route_stops`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operating_sessions`
--
ALTER TABLE `operating_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operations_service_options`
--
ALTER TABLE `operations_service_options`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `operation_assignments`
--
ALTER TABLE `operation_assignments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_log`
--
ALTER TABLE `operation_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `operation_repairs`
--
ALTER TABLE `operation_repairs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_repair_history`
--
ALTER TABLE `operation_repair_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_session_invites`
--
ALTER TABLE `operation_session_invites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_session_participants`
--
ALTER TABLE `operation_session_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_switch_lists`
--
ALTER TABLE `operation_switch_lists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_switch_list_moves`
--
ALTER TABLE `operation_switch_list_moves`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_switch_moves`
--
ALTER TABLE `operation_switch_moves`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_switch_sessions`
--
ALTER TABLE `operation_switch_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_yard_assignments`
--
ALTER TABLE `operation_yard_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operation_yard_history`
--
ALTER TABLE `operation_yard_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prepared_cuts`
--
ALTER TABLE `prepared_cuts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `railroads`
--
ALTER TABLE `railroads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `repair_queue`
--
ALTER TABLE `repair_queue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `user_settings`
--
ALTER TABLE `user_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `waybills`
--
ALTER TABLE `waybills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `waybill_cycles`
--
ALTER TABLE `waybill_cycles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_remember_tokens`
--
ALTER TABLE `auth_remember_tokens`
  ADD CONSTRAINT `fk_auth_remember_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `equipment`
--
ALTER TABLE `equipment`
  ADD CONSTRAINT `fk_equipment_railroad` FOREIGN KEY (`railroad_id`) REFERENCES `railroads` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_assignments`
--
ALTER TABLE `operation_assignments`
  ADD CONSTRAINT `fk_operation_assignment_predecessor` FOREIGN KEY (`predecessor_assignment_id`) REFERENCES `operation_assignments` (`id`),
  ADD CONSTRAINT `fk_operation_assignment_session` FOREIGN KEY (`session_id`) REFERENCES `operating_sessions` (`id`);

--
-- Constraints for table `operation_assignment_locomotives`
--
ALTER TABLE `operation_assignment_locomotives`
  ADD CONSTRAINT `fk_assignment_locomotive_assignment` FOREIGN KEY (`assignment_id`) REFERENCES `operation_assignments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_assignment_starting_cars`
--
ALTER TABLE `operation_assignment_starting_cars`
  ADD CONSTRAINT `fk_assignment_starting_car_assignment` FOREIGN KEY (`assignment_id`) REFERENCES `operation_assignments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_repair_history`
--
ALTER TABLE `operation_repair_history`
  ADD CONSTRAINT `fk_operation_repair_history_repair` FOREIGN KEY (`repair_id`) REFERENCES `operation_repairs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_session_invites`
--
ALTER TABLE `operation_session_invites`
  ADD CONSTRAINT `fk_session_invite_session` FOREIGN KEY (`session_id`) REFERENCES `operating_sessions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_session_participants`
--
ALTER TABLE `operation_session_participants`
  ADD CONSTRAINT `fk_session_participant_invite` FOREIGN KEY (`invite_id`) REFERENCES `operation_session_invites` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_session_roles`
--
ALTER TABLE `operation_session_roles`
  ADD CONSTRAINT `fk_operation_session_role_railroad` FOREIGN KEY (`railroad_id`) REFERENCES `railroads` (`id`),
  ADD CONSTRAINT `fk_operation_session_role_session` FOREIGN KEY (`session_id`) REFERENCES `operating_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_operation_session_role_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `operation_switch_lists`
--
ALTER TABLE `operation_switch_lists`
  ADD CONSTRAINT `fk_operation_switch_list_assignment` FOREIGN KEY (`assignment_id`) REFERENCES `operation_assignments` (`id`),
  ADD CONSTRAINT `fk_operation_switch_list_session` FOREIGN KEY (`session_id`) REFERENCES `operating_sessions` (`id`);

--
-- Constraints for table `operation_switch_list_moves`
--
ALTER TABLE `operation_switch_list_moves`
  ADD CONSTRAINT `fk_switch_list_move_list` FOREIGN KEY (`switch_list_id`) REFERENCES `operation_switch_lists` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_switch_moves`
--
ALTER TABLE `operation_switch_moves`
  ADD CONSTRAINT `fk_operation_switch_moves_session` FOREIGN KEY (`switch_session_id`) REFERENCES `operation_switch_sessions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_yard_assignments`
--
ALTER TABLE `operation_yard_assignments`
  ADD CONSTRAINT `fk_yard_assignment_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`id`),
  ADD CONSTRAINT `fk_yard_assignment_industry` FOREIGN KEY (`yard_industry_id`) REFERENCES `industries` (`id`),
  ADD CONSTRAINT `fk_yard_assignment_railroad` FOREIGN KEY (`railroad_id`) REFERENCES `railroads` (`id`),
  ADD CONSTRAINT `fk_yard_assignment_session` FOREIGN KEY (`session_id`) REFERENCES `operating_sessions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `operation_yard_history`
--
ALTER TABLE `operation_yard_history`
  ADD CONSTRAINT `fk_yard_history_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`id`),
  ADD CONSTRAINT `fk_yard_history_from_industry` FOREIGN KEY (`from_yard_industry_id`) REFERENCES `industries` (`id`),
  ADD CONSTRAINT `fk_yard_history_railroad` FOREIGN KEY (`railroad_id`) REFERENCES `railroads` (`id`),
  ADD CONSTRAINT `fk_yard_history_session` FOREIGN KEY (`session_id`) REFERENCES `operating_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_yard_history_to_industry` FOREIGN KEY (`to_yard_industry_id`) REFERENCES `industries` (`id`);

--
-- Constraints for table `prepared_cut_cars`
--
ALTER TABLE `prepared_cut_cars`
  ADD CONSTRAINT `fk_prepared_cut_car_cut` FOREIGN KEY (`prepared_cut_id`) REFERENCES `prepared_cuts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `railroads`
--
ALTER TABLE `railroads`
  ADD CONSTRAINT `fk_railroad_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD CONSTRAINT `fk_user_settings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `waybills`
--
ALTER TABLE `waybills`
  ADD CONSTRAINT `waybills_ibfk_1` FOREIGN KEY (`railroad_id`) REFERENCES `railroads` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `waybills_ibfk_2` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `waybills_ibfk_3` FOREIGN KEY (`origin_industry_id`) REFERENCES `industries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `waybills_ibfk_4` FOREIGN KEY (`destination_industry_id`) REFERENCES `industries` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `waybill_cycles`
--
ALTER TABLE `waybill_cycles`
  ADD CONSTRAINT `waybill_cycles_ibfk_1` FOREIGN KEY (`waybill_id`) REFERENCES `waybills` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;