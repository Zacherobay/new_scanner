#!/bin/bash
    
write_header() {
    local target="$1"
    echo "------------------------------"
    echo "  Network Security Scan Report  "
    echo "------------------------------"
    echo ""
    echo "Target: $target"
    echo ""
}

write_ports_section() {
    echo "--- Open Ports and Detected Services ---"
    nmap -sV "$TARGET" | grep "open"
    echo ""
}

write_vulns_section() {
    echo "--- Potential Vulnerabilities Identified ---"
    # Run nmap with vuln scripts and capture output
    SCAN_RESULTS=$(nmap -sV --script vuln "$TARGET")
    # Grep for high-confidence vulnerabilities
    VULN_FOUND=$(echo "$SCAN_RESULTS" | grep "VULNERABLE")
    if [ -n "$VULN_FOUND" ]; then
        echo "$VULN_FOUND"
    else
        echo "No high-confidence vulnerabilities found by NSE scripts."
    fi
    echo ""
}

write_recs_section() {
    echo "--- Recommendations for Remediation ---"
    echo "1. Update all software and operating systems to the latest versions."
    echo "2. Change default credentials on all services immediately."
    echo "3. Implement and configure a firewall to restrict unnecessary access."
    echo "4. Conduct regular vulnerability scanning and penetration testing."
    echo ""
}

write_footer() {
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "--- End of Report ---"
    echo "Report Generated on: $timestamp"
}

main() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <target_ip_or_hostname>" >&2
        exit 1
    fi

    local TARGET="$1"
    local REPORT_FILE="network_security_report.txt"

    write_header "$TARGET" > "$REPORT_FILE"
    write_ports_section >> "$REPORT_FILE"
    write_vulns_section >> "$REPORT_FILE"
    write_recs_section >> "$REPORT_FILE"
    write_footer >> "$REPORT_FILE"

}

main "$@"
