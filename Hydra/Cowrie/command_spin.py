from cowrie.shell.command import HoneyPotCommand
import time

class command_spin(HoneyPotCommand):
    def start(self):
        attacker_ip = self.protocol.transport.getPeer().host
        self.write(f"spin: Executing subsystem logic on target {attacker_ip}...\n")
        time.sleep(2)
        self._log_to_hydra(attacker_ip)
        self.exit()
        
    def _log_to_hydra(self, ip):
        event = {
            "event": "spin_exec",
            "attacker_ip": ip,
            "action": "Executed spin logic",
            "notes": "Triggered dummy exec and fingerprinting trap"
        }
        self.logger.msg("hydra::spin", **event)

commands = {
    '/usr/bin/spin': command_spin,
    '/bin/spin': command_spin
}
