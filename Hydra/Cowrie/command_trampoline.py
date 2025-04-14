from cowrie.shell.command import HoneyPotCommand
import time

class command_trampoline(HoneyPotCommand):
    def start(self):
        self.write("Attempting trampoline privilege escalation...\n")
        time.sleep(1.5)
        self.write("Segmentation fault (core dumped)\n")
        self._log_attempt()
        self.exit()
        
    def _log_attempt(self):
        attacker_ip = self.protocol.transport.getPeer().host
        self.logger.msg("hydra::trampoline", attacker_ip=attacker_ip, tool="trampoline", result="fail", notes="Priv-esc bait triggered")
        
commands = {
    '/usr/bin/trampoline': command_trampoline,
    '/bin/trampoline': command_trampoline
}
