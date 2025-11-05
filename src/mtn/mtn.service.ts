import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { AuthenticateDistributorDto } from './dto/authenticate-distributor.dto';

@Injectable()
export class MtnService {
  private readonly MTN_API_URL = 'https://Servicestest.mtnsyr.com:985/authenticateDistributor';

  constructor(private readonly httpService: HttpService) {}

  async authenticateDistributor(data?: AuthenticateDistributorDto) {
    try {
      // Use provided data or default values
      const inputObj = data || {
        uesrName: '3tech_Test',
        password: '$3techTestMTN',
        DistributorCode: '270193784',
      };

      const response = await firstValueFrom(
        this.httpService.post(this.MTN_API_URL, { inputObj }),
      );

      return {
        success: true,
        data: response.data,
        status: response.status,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.response?.data?.message || 'Failed to authenticate distributor',
          error: error.response?.data || error.message,
        },
        error.response?.status || HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}

