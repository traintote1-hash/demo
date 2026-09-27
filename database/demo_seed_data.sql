-- Minimal local seed owner for enter_demo.php. This account is inactive and has
-- no usable password; visitors receive a separate temporary account at runtime.
INSERT INTO users (
    id, first_name, last_name, email, password_hash, is_active, demo_user, expires_at
) VALUES (
    2, 'Demo', 'Seed', 'demo-seed@example.invalid', '!disabled-seed-account!', 0, 0, NULL
);

INSERT INTO railroads (
    id, user_id, name, era, region, operating_style, description,
    is_default, seed_data, operations_dispatcher_enabled
) VALUES (
    1, 2, 'TrainTote Demo Seed', 'Modern', 'South', 'Hybrid',
    'Seed railroad used to create isolated demo accounts.', 1, 1, 0
);
