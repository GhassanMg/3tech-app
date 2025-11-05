import { Body, Controller, Post } from '@nestjs/common';
import { MtnService } from './mtn.service';
import { AuthenticateDistributorDto } from './dto/authenticate-distributor.dto';

@Controller('api/v1/mtn')
export class MtnController {
  constructor(private readonly mtnService: MtnService) {}

  @Post('authenticate-distributor')
  async authenticateDistributor(@Body() body?: AuthenticateDistributorDto) {
    return this.mtnService.authenticateDistributor(body);
  }
}

