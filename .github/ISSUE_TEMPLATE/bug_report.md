---
name: 🐛 Bug Report
about: Report a bug in the Ansible configuration management deployment
title: "[BUG] "
labels: "bug"
assignees: ""
---

## 🐛 Bug Description

### Affected Component

- [ ] Ansible playbook
- [ ] `flask_app` role
- [ ] `splunk_monitoring` role
- [ ] Service templates (app.service.j2, frontend.service.j2)
- [ ] Inventory management
- [ ] Deployment automation
- [ ] Documentation
- [ ] Other: ******\_\_\_******

### What happened?

<!-- Clear description of the bug -->

### What should have happened?

<!-- Expected behavior -->

---

## 🔄 Reproduction Steps

1. Step 1
2. Step 2
3. Step 3

## 🌐 Environment

- **Ansible Version:**
- **Target OS:** Amazon Linux 2 / RHEL 8+ / Other: ******\_\_\_******
- **Python Version:**
- **AWS Region:**
- **Affected Service:** [ ] carprice (Port 5002) [ ] carprice-frontend (Port 3000) [ ] Both

### Playbook Execution Command

```bash
ansible-playbook -i inventory.ini playbook.yml -vv
```

## 📋 Error Details

### Full Error Output

```
Paste complete error logs here
```

### Ansible Debug Output

```bash
ansible-playbook -i inventory.ini playbook.yml -vv --check
```

### System Logs

```bash
# Relevant systemd logs
journalctl -u carprice -n 50
journalctl -u carprice-frontend -n 50
```

## 📊 Additional Context

### Playbook Variables

```yaml
# Relevant variables that might be causing the issue
```

### Service Status

```bash
systemctl status carprice
systemctl status carprice-frontend
```

## ✅ Verification Checklist

- [ ] Bug reproduced with dry-run (`--check` mode)
- [ ] Bug reproduced in full deployment
- [ ] Error logs collected (verbosity -vv or -vvv)
- [ ] Systemd logs reviewed
- [ ] Configuration variables documented
- [ ] No sensitive data in logs

**Priority:** [ ] Critical [ ] High [ ] Medium [ ] Low

**Severity Impact:**

- [ ] Deployment blocked
- [ ] Service degradation
- [ ] Partial functionality issue
- [ ] Minor issue
