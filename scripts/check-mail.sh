
#!/usr/bin/env bash
# ~/check-mail.sh
mbsync -q -c ~/.mbsyncrc gmail 2>/dev/null
echo "Mail: $(ls -1 ~/Mail/gmail/INBOX/new 2>/dev/null | wc -l)"
